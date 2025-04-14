---- find the string "nothing"
function c7423753.initial_effect(c)
	--if c2023753.global_effect then return end
	--match kill
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e4:SetCode(EFFECT_MATCH_KILL)
	c:RegisterEffect(e4)
	local move=(function()
		local ct=Duel.GetFieldGroupCount(0,0,LOCATION_DECK)
		local ct2=Duel.GetFieldGroupCount(0,LOCATION_EXTRA,0)
		local tp=0
		if ct>0 or ct2>0
		then tp=1 end
		Duel.DisableShuffleCheck()
		--Duel.SpecialSummon(c,0,tp,tp,true,true,POS_FACEUP_ATTACK)
		Duel.MoveToField(c,tp,tp,LOCATION_MZONE,POS_FACEUP_ATTACK,false)
	end)
	local attack=(function()
		Duel.CalculateDamage(c,nil,false)
	end)
	Duel.DisableActionCheck(true)
	pcall(move)
	Duel.DisableActionCheck(false)
	Duel.DisableActionCheck(true)
	pcall(attack)
	Duel.DisableActionCheck(false)
	--
	Duel={}
	Effect={}
	Card={}
	Group={}
	Debug={}
	bit={}
	aux={}
	xgl={}
	math={}
	string={}
	self={}
	table={}
	Auxiliary={}
	Glitchy={}
	coroutine={}
	userdata={}
	io={}
	assert={}
	collectgarbage={}
	dofile={}
	error={}
	_G=nil
	getfenv={}
	getmetatable={}
	ipairs={}
	load={}
	loadfile={}
	loadstring={}
	next={}
	print={}
	pairs={}
	pcall={}
	rawequal={}
	rawget={}
	rawset={}
	select={}
	setfenv={}
	setmetatable={}
	tostring={}
	tonumber={}
	type={}
	unpack={}
	_VERSION={}
	xpcall={}
end
