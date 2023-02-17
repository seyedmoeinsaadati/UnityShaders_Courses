using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[RequireComponent (typeof(Player))]
public class PlayerController : MonoBehaviour
{

	[SerializeField] Player player;


	void Awake ()
	{
		player = GetComponent<Player> ();
	}

	// Use this for initialization
	void Start ()
	{
		
	}
	
	// Update is called once per frame
	void Update ()
	{
		Control ();
	}

	void Control ()
	{
	}
}