using UnityEngine;
using System.Collections;
using UnityEngine.UI;
using System.Collections.Generic;

public class Player : MonoBehaviour
{
	RaycastHit hit;
	public Camera fpsCamera;

	void Awake ()
	{
	}

	void Start ()
	{
	}
		
	// Update is called once per frame
	void Update ()
	{
		
	}
		
	GameObject getGameObject ()
	{
		bool raycastHit = Physics.Raycast (fpsCamera.transform.position, fpsCamera.transform.forward, out hit, 100);
		if (raycastHit) {
			return hit.collider.gameObject;
		} else {
			return null;
		}
	}

	// shoot function isn't belong here, move it to weapon scripts later
	public void Shoot ()
	{
		GameObject g = getGameObject ();
		if (g == null)
			return;
		
		Rigidbody rb = g.GetComponent<Rigidbody> ();
		if (rb != null) {
			Debug.Log ("Time Object : " + hit.collider.name);	
			rb.AddForce (fpsCamera.transform.forward * 500);	
		}
	}

	void ShowMessage (string msg)
	{
		Debug.Log (msg);
	}
}
