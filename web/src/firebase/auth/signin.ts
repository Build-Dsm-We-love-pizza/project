import firebase_app from "../config";
import {
  createUserWithEmailAndPassword,
  getAuth,
  signInWithEmailAndPassword,
  signOut,
} from "firebase/auth";

const auth = getAuth(firebase_app);

export async function singUp(email: string, password: string) {
  let result = null,
    error = null;
  try {
    result = await createUserWithEmailAndPassword(auth, email, password);
  } catch (e) {
    error = e;
  }
}

export async function singIn(email: string, password: string) {
  let result = null,
    error = null;
  try {
    result = await signInWithEmailAndPassword(auth, email, password);
    console.log(result);
  } catch (e) {
    console.log(e);
    error = e;
  }

  return { result, error };
}

export async function signOuFunction() {
  try {
    await signOut(auth);
  } catch (err) {}
}
