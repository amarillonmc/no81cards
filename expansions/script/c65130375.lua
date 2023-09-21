--无尽镜界
local s,id,o=GetID()
if not pcall(require,"expansions/script/c65199999") then pcall(require,"script/c65199999") end
function s.initial_effect(c)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_FZONE)
	e1:SetProperty(EFFECT_FLAG_BOTH_SIDE)
	e1:SetCountLimit(1,EFFECT_COUNT_CODE_SINGLE)
	e1:SetCondition(s.spcon)
	e1:SetTarget(s.sptg)
	e1:SetOperation(s.spop)
	c:RegisterEffect(e1)
	--special summon
	local e2=e1:Clone()
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_PHASE+PHASE_BATTLE_START)
	c:RegisterEffect(e2)
	--draw skip
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetCode(EFFECT_CANNOT_DRAW)
	e3:SetRange(LOCATION_FZONE)
	e3:SetTargetRange(1,0)
	e3:SetCondition(function ()
		return Duel.GetCurrentPhase()==PHASE_DRAW
	end)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EFFECT_DRAW_COUNT)
	e4:SetValue(0)
	c:RegisterEffect(e4)
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e5:SetCode(EVENT_ADJUST)
	e5:SetRange(LOCATION_FZONE)
	e5:SetCondition(s.mjcon)
	e5:SetOperation(s.mjop)
	c:RegisterEffect(e5)
	--Change
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e6:SetCode(EVENT_ADJUST)
	e6:SetRange(LOCATION_FZONE)
	e6:SetCondition(s.changecon1)
	e6:SetOperation(s.changeop1)
	c:RegisterEffect(e6)
	local e7=e6:Clone()
	e6:SetCondition(s.changecon2)
	e6:SetOperation(s.changeop2)
	c:RegisterEffect(e7)
end
function s.spcon(e,tp,eg,ep,ev,re,r,rp)
	return tp~=e:GetHandler():GetControler()
end
function s.spfilter(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.cspfilter(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsType(TYPE_MONSTER)
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToDeck,tp,LOCATION_ONFIELD+LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil) and Duel.GetLocationCount(tp,LOCATION_MZONE) and Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_HAND,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,0,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local op1=Duel.IsExistingMatchingCard(Card.IsAbleToDeck,tp,LOCATION_ONFIELD+LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil) and Duel.GetLocationCount(tp,LOCATION_MZONE) and Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_HAND,0,1,nil,e,tp)
	local op2=#Mirrors_World_Card>0
	if op1 and (not op2 or Duel.SelectOption(tp,aux.Stringid(id,1),aux.Stringid(id,2))==0) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
		local g=Duel.SelectMatchingCard(tp,Card.IsAbleToDeck,tp,LOCATION_ONFIELD+LOCATION_GRAVE+LOCATION_REMOVED,0,1,5,nil)
		Duel.SendtoDeck(g,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
		local ct=Duel.GetLocationCount(tp,LOCATION_MZONE)
		if ct<=0 then return end
		if Duel.IsPlayerAffectedByEffect(tp,59822133) then ct=1 end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,s.spfilter,tp,LOCATION_HAND,0,1,ct,nil,e,tp)
		if g:GetCount()>0 then
			Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
		end
	elseif op2 then
		local sg=Group.CreateGroup()
		for i,value in ipairs(Mirrors_World_Card) do
			sg:AddCard(Duel.CreateToken(tp,value))
		end
		local tc=sg:Select(tp,1,1,nil):GetFirst()
		sg:DeleteGroup()
		Duel.SendtoDeck(tc,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
		local code=tc:GetOriginalCode()
		
		local cg=Group.CreateGroup()
		local strNumber = tostring(code)
		if #strNumber==10 then
			Debug.Message("救命，怎么会有10位的卡号")
		end
		local _TGetID=GetID
		if not _G["c"..code] then
			_G["c"..code]={}
			_G["c"..code].__index=_G["c"..code]
		end
		GetID=function()
			return _G["c"..code],code
		end
		if pcall(require,"expansions/script/c"..code) and #strNumber~=10 then
			local prefix,randommax
			if #strNumber==9 then
				prefix=tonumber(strNumber:sub(1,4))
				randommax=99999
			elseif #strNumber==7 then
				prefix=tonumber(strNumber:sub(1,3))
				randommax=9999
			elseif #strNumber==6 then
				prefix=tonumber(strNumber:sub(1,3))
				randommax=999
			elseif #strNumber==5 then
				prefix=tonumber(strNumber:sub(1,3))
				randommax=99
			elseif #strNumber==4 then
				prefix=0
				randommax=9999
			else
				prefix=tonumber(strNumber:sub(1,3))
				randommax=99999
			end
			for i=1,4 do
				while not ac do
					local int=zsx_roll(0,randommax)
					rcode=prefix*(randommax+1)+int
					local cc,ca,ctype=Duel.ReadCard(rcode,CARDDATA_CODE,CARDDATA_ALIAS,CARDDATA_TYPE)
					GetID=function()
						return _G["c"..code],code
					end
					if cc then
						local dif=cc-ca
						local real=0
						if dif>-10 and dif<10 then
							real=ca
						else
							real=cc
						end
						if ctype&TYPE_TOKEN==0 and pcall(require,"expansions/script/c"..real) then
							ac=real
						end
					end
					GetID=_TGetID
				end
				Duel.Hint(HINT_CARD,0,ac)
				cg:AddCard(Duel.CreateToken(tp,ac))
				ac=nil
			end
			local ac=zsx_CreateCode()
			Duel.Hint(HINT_CARD,0,ac)
			cg:AddCard(Duel.CreateToken(tp,ac))
		else
			for i=1,5 do
				local ac=zsx_CreateCode()
				Duel.Hint(HINT_CARD,0,ac)
				cg:AddCard(Duel.CreateToken(tp,ac))
			end
		end
		local cg1=cg:Filter(s.cspfilter,nil,e,tp)
		local ctc=cg1:GetFirst()
		while ctc and Duel.GetMZoneCount(tp)>0 do
			if zsx_RandomSpecialSummon(ctc,0,tp,tp,false,false,POS_FACEUP)==1 then
				cg:RemoveCard(ctc)
			end
			ctc=cg1:GetNext()
		end
		Duel.SendtoHand(cg,nil,REASON_EFFECT)
	end
end
function s.mjcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return Duel.GetMatchingGroupCount(Card.IsCode,c:GetControler(),LOCATION_ONFIELD,0,nil,id+1)==0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
end
function s.mjop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsPlayerCanSpecialSummonMonster(tp,id+1,0,TYPES_TOKEN_MONSTER,0,0,1,RACE_SPELLCASTER,nil,POS_FACEUP) then
		local token=Duel.CreateToken(tp,id+1)
		Duel.SpecialSummonStep(token,0,tp,tp,false,false,POS_FACEUP)
		--cannot atk
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e1:SetCode(EFFECT_IGNORE_BATTLE_TARGET)
		e1:SetRange(LOCATION_MZONE)
		e1:SetValue(1)
		token:RegisterEffect(e1,true)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_ATTACK_ALL)
		e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e2:SetValue(1)
		token:RegisterEffect(e2,true)
		--atk/def
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_SINGLE)
		e3:SetCode(EFFECT_UPDATE_ATTACK)
		e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e3:SetRange(LOCATION_MZONE)
		e3:SetValue(function (e,c)
			return Duel.GetLP(c:GetControler())
		end)
		token:RegisterEffect(e3,true)
		local e4=e3:Clone()
		e4:SetCode(EFFECT_UPDATE_DEFENSE)
		token:RegisterEffect(e4,true)
		Duel.SpecialSummonComplete()
	end
end
function s.changecon1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return Duel.GetLP(c:GetControler())<=60000 and Duel.GetLP(c:GetControler())>30000 and Duel.GetFlagEffect(c:GetControler(),id)==0
end
function s.changeop1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.RegisterFlagEffect(c:GetControler(),id,0,0,1)
	c:SetEntityCode(65130379)
	c:SetEntityCode(65130377)
end
function s.changecon2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return Duel.GetLP(c:GetControler())<=30000 and Duel.GetFlagEffect(c:GetControler(),id)<=1
end
function s.changeop2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.RegisterFlagEffect(c:GetControler(),id,0,0,1)
	Duel.RegisterFlagEffect(c:GetControler(),id,0,0,1)
	c:SetEntityCode(65130379)
	c:SetEntityCode(65130378)
end