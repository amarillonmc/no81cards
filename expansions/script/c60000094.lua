--邪恶的指挥
local cm,m,o=GetID()
function cm.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
	if not cm.global_check then
		cm.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_DAMAGE)
		ge1:SetOperation(cm.checkop)
		Duel.RegisterEffect(ge1,0)
	end
end
function cm.checkop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetTurnPlayer()==ep then
		Duel.RegisterFlagEffect(ep,m,0,0,1)
	end
end
function cm.filter(c,e,tp)
	return c:IsLevelBelow(4) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function cm.tkfil(c,tp)
	return c:IsCanHaveCounter(0x624) and Duel.IsCanAddCounter(tp,0x624,1,c) and c:IsFaceup()
end
function cm.tkfil2(c,e,tp)
	return c:IsCanHaveCounter(0x624) and Duel.IsCanAddCounter(tp,0x624,1,c) and cm.filter(c,e,tp)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.tkfil,tp,LOCATION_MZONE,0,1,nil,tp) 
	or (Duel.IsExistingMatchingCard(cm.tkfil2,tp,LOCATION_HAND,0,1,nil,e,tp) and Duel.GetFlagEffect(tp,m)>=7 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFlagEffect(tp,m)>=7 then
		if Duel.IsExistingMatchingCard(cm.tkfil,tp,LOCATION_MZONE,0,1,nil,tp) then
			if Duel.IsExistingMatchingCard(cm.tkfil2,tp,LOCATION_HAND,0,1,nil,e,tp) and Duel.GetFlagEffect(tp,m)>=7 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.SelectYesNo(tp,aux.Stringid(m,0)) then
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
				local g=Duel.SelectMatchingCard(tp,cm.filter,tp,LOCATION_HAND,0,1,1,nil,e,tp)
				if g:GetCount()>0 then
					Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
				end
			end
		else
			if Duel.IsExistingMatchingCard(cm.tkfil2,tp,LOCATION_HAND,0,1,nil,e,tp) and Duel.GetFlagEffect(tp,m)>=7 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
				local g=Duel.SelectMatchingCard(tp,cm.tkfil2,tp,LOCATION_HAND,0,1,1,nil,e,tp)
				if g:GetCount()>0 then
					Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
				end
			end
		end
	end
	if not Duel.IsExistingMatchingCard(cm.tkfil,tp,LOCATION_MZONE,0,1,nil,tp) then return end
	if Duel.Damage(tp,100,REASON_EFFECT)~=0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
		local tc=Duel.SelectMatchingCard(tp,cm.tkfil,tp,LOCATION_MZONE,0,1,1,nil,tp):GetFirst()
		tc:AddCounter(0x624,1)
		Duel.RegisterFlagEffect(tp,60002148,0,0,1)
	end
end