import * as admin from "firebase-admin";
import { onDocumentWritten } from "firebase-functions/v2/firestore";
import { setGlobalOptions } from "firebase-functions/v2";

admin.initializeApp();

// HATA VEREN eventarc objesini kaldırmak için bu global ayarları kullanın
// Fonksiyonun çalıştığı bölgeyi ve dinlediği Firestore bölgesini burada tanımlayın.
setGlobalOptions({
    region: "europe-west1", // Cloud Function'ın çalıştığı bölge (Burayı dilediğiniz bölge yapabilirsiniz)
    concurrency: 10,        // (Opsiyonel) Eşzamanlılık sınırı ekleyebilirsiniz
    // eventarc.location'ı buraya taşımak yerine, Firestore veritabanınızın
    // bölgesi olan "eur3" bölgesini kullanmak isterseniz, `region` kısmını "eur3" yapın
});

function exerciseIdFromName(name: string): string {
    return name.trim().toLowerCase().replace(/[^\w\s]/g, "").replace(/\s+/g, "_");
}

export const onUserExerciseRatingWrite = onDocumentWritten(
  {
    document: "users/{uid}/user_exercises/{exerciseName}",
    // ARTIK eventarc: { location: "eur3" } GEREKSİZ ve KALDIRILDI.
  },
  async (event) => {
    // ... (Fonksiyon gövdesi aynı kalır)
    const before = event.data?.before.exists ? event.data.before.data()! : null;
    const after  = event.data?.after.exists  ? event.data.after.data()!  : null;
    if (!after) return;

    const prev = before?.rating as number | undefined;
    const next = after?.rating  as number | undefined;
    if (typeof next !== "number" || next < 1 || next > 5) return;
    if (prev === next) return;

    const exerciseName = event.params["exerciseName"] as string;
    const exerciseId = exerciseIdFromName(exerciseName);
    const exRef = admin.firestore().collection("exercises").doc(exerciseId);

    await admin.firestore().runTransaction(async (tx) => {
      const snap = await tx.get(exRef);
      const data = snap.exists ? (snap.data() as any) : {};
      const ratingCount = (data?.ratingCount as number) ?? 0;
      const sumStars    = (data?.sumStars    as number) ?? 0;

      let newCount = ratingCount;
      let newSum   = sumStars;

      if (typeof prev === "number") {
        newSum = sumStars - prev + next;
      } else {
        newCount = ratingCount + 1;
        newSum   = sumStars + next;
      }

      const average = newCount > 0 ? newSum / newCount : 0;
      tx.set(exRef, { ratingCount: newCount, sumStars: newSum, average }, { merge: true });
    });
  }
);
