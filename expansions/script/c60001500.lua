--狼人女王·卢娜
local cm,m,o=GetID()
function cm.initial_effect(c)
	c:EnableCounterPermit(0x624)
	--to hand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DAMAGE+CATEGORY_DECKDES+CATEGORY_GRAVE_SPSUMMON)
	e1:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetTarget(cm.thtg)
	e1:SetOperation(cm.thop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
	
	--Evolve
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,1))
	e3:SetCategory(CATEGORY_DAMAGE+CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetCondition(cm.incon)
	--e3:SetTarget(cm.atg)
	e3:SetOperation(cm.aop)
	c:RegisterEffect(e3)
	
	if not cm.global_check then
		cm.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_DAMAGE)
		ge1:SetOperation(cm.checkop)
		Duel.RegisterEffect(ge1,0)
	end
	--attackup
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetCondition(cm.incon)
	e3:SetValue(800)
	c:RegisterEffect(e3)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EFFECT_UPDATE_DEFENSE)
	e3:SetCondition(cm.incon)
	e3:SetValue(800)
	c:RegisterEffect(e3)
end
function cm.checkop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetTurnPlayer()==ep then
		Duel.RegisterFlagEffect(ep,m,0,0,1)
	end
end
function cm.incon(e)
	return Card.GetCounter(e:GetHandler(),0x624)>=1
end
function cm.filter(c,e,tp)
	return c:IsCode(m+1) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function cm.filter2(c,e,tp)
	return c:IsCanHaveCounter(0x624) and Duel.IsCanAddCounter(tp,0x624,1,c) and c:IsRace(RACE_FIEND) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsLevelBelow(3)
end
function cm.ckfil(c,tp)
	return c:IsCanHaveCounter(0x624) and Duel.IsCanAddCounter(tp,0x624,1,c) and c:IsFaceup()
end
function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function cm.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	if Duel.Damage(tp,1,REASON_EFFECT)~=0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,cm.filter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,e,tp)
		if g:GetCount()>0 and Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)~=0 and Duel.GetFlagEffect(tp,m)>=7 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(cm.filter2,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil,e,tp) and Duel.SelectYesNo(tp,aux.Stringid(m,0)) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local g=Duel.SelectMatchingCard(tp,cm.filter2,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,e,tp)
			if g:GetCount()>0 and Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)~=0 then
				local g=Duel.GetMatchingGroup(cm.ckfil,tp,LOCATION_MZONE,0,nil,tp)
				for tc in aux.Next(g) do
					tc:AddCounter(0x624,1)
					Duel.RegisterFlagEffect(tp,60002148,0,0,1)
				end
			end
		end
	end
end
function cm.ckfil2(c)
	return c:GetCounter(0x624)~=0 and c:IsFaceup()
end
function cm.atg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(cm.ckfil2,tp,LOCATION_MZONE,0,nil)
	if chk==0 then return Duel.GetLP(tp)>100*(#g+1) end
end
function cm.aop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(cm.ckfil2,tp,LOCATION_MZONE,0,nil)
	--if Duel.GetLP(tp)<=100*(#g+1) then return end
	for i=1,#g+1 do
		if Duel.Damage(tp,100,REASON_EFFECT)~=0 and Duel.SelectYesNo(tp,aux.Stringid(m,1)) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
			local g=Duel.SelectMatchingCard(tp,aux.TRUE,tp,0,LOCATION_ONFIELD,1,1,nil)
			Duel.Destroy(g,REASON_EFFECT)
		end
	end
end