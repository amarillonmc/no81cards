--增加的威胁
function c33700142.initial_effect(c)
	 --Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN) 
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetTarget(c33700142.target)
	e1:SetOperation(c33700142.activate)
	c:RegisterEffect(e1)
end
function c33700142.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroupCount(Card.IsType,tp,LOCATION_MZONE,0,nil,TYPE_TOKEN)
	 local ft=Duel.GetMZoneCount(tp)
	 if g>ft  then
	g=ft
   end
   if Duel.IsPlayerAffectedByEffect(tp,59822133) then
   g=1
end
	if chk==0 then return ft>0 end
	  local cg=Duel.SelectTarget(tp,Card.IsType,tp,LOCATION_MZONE,0,1,g,nil,TYPE_TOKEN)
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,cg:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,cg:GetCount(),0,0)
end
function c33700142.activate(e,tp,eg,ep,ev,re,r,rp)
	local ft=Duel.GetMZoneCount(tp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local sg=g:Filter(Card.IsRelateToEffect,nil,e)
	 if ft<=0 then return end
	if sg:GetCount()>1 and Duel.IsPlayerAffectedByEffect(tp,59822133) then return end
	if sg:GetCount()>ft then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		sg=sg:Select(tp,ft,ft,nil)
	end
	local tc=sg:GetFirst()
	while tc do
	if  Duel.IsPlayerCanSpecialSummonMonster(tp,tc:GetCode(),0,0x4011,tc:GetAttack(),tc:GetDefense(),
	tc:GetLevel(),tc:GetRace(),tc:GetAttribute()) then
	local token=Duel.CreateToken(tp,33700142) 
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SET_BASE_ATTACK)
	e1:SetValue(tc:GetAttack())
	e1:SetReset(RESET_EVENT+0xfe0000)
	token:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_SET_BASE_DEFENSE)
	e2:SetValue(tc:GetDefense())
	token:RegisterEffect(e2)
	local e3=e1:Clone()
	e3:SetCode(EFFECT_CHANGE_LEVEL)
	e3:SetValue(tc:GetLevel())
	token:RegisterEffect(e3)
	local e4=e1:Clone()
	e4:SetCode(EFFECT_CHANGE_RACE)
	e4:SetValue(tc:GetRace())
	token:RegisterEffect(e4)
	local e5=e1:Clone()
	e5:SetCode(EFFECT_CHANGE_ATTRIBUTE)
	e5:SetValue(tc:GetAttribute())
	token:RegisterEffect(e5)
	local e6=e1:Clone()
	e6:SetCode(EFFECT_CHANGE_CODE)
	e6:SetValue(tc:GetCode())
	token:RegisterEffect(e6)
	Duel.SpecialSummonStep(token,0,tp,tp,false,false,POS_FACEUP)
	end
	tc=sg:GetNext()
end
	Duel.SpecialSummonComplete()
end
