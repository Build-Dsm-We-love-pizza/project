import React, { useEffect, useState } from "react";
import { onAuthStateChanged, getAuth, User } from "firebase/auth";
import firebase_app from "@/firebase/config";

const auth = getAuth(firebase_app);

function useAuthState() {
  const [user, setUser] = useState<User | null>();
  const [isLoading, setIsLoading] = useState<boolean | null>(null);

  const getToken = async () => {
    const token = await auth.currentUser?.getIdToken(true);
    console.log(token);
  };

  useEffect(() => {
    const unsubscribe = onAuthStateChanged(auth, (user) => {
      getToken();
      if (user) {
        setUser(user);
      } else {
        setUser(null);
      }
      setIsLoading(false);
    });

    return () => unsubscribe();
  }, []);

  return { user, isLoading };
}

export default useAuthState;
