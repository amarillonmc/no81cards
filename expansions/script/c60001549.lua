--崭新的少女·欧丝
local cm,m,o=GetID()
function cm.initial_effect(c)
	c:EnableCounterPermit(0x624)
	--eup
	local ee1=Effect.CreateEffect(c)
	ee1:SetType(EFFECT_TYPE_SINGLE)
	ee1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	ee1:SetRange(LOCATION_MZONE)
	ee1:SetCode(EFFECT_UPDATE_ATTACK)
	ee1:SetCondition(cm.incon)
	ee1:SetValue(800)
	c:RegisterEffect(ee1)
	local ee2=ee1:Clone()
	ee2:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(ee2)
	local ee3=Effect.CreateEffect(c)
	ee3:SetDescription(aux.Stringid(m,2))
	ee3:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_GRAVE_SPSUMMON)
	ee3:SetType(EFFECT_TYPE_QUICK_O)
	ee3:SetCode(EVENT_FREE_CHAIN)
	ee3:SetRange(LOCATION_MZONE)
	ee3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL+EFFECT_FLAG_NO_TURN_RESET)
	ee3:SetCountLimit(1)
	ee3:SetCondition(cm.incon)
	ee3:SetTarget(cm.etg)
	ee3:SetOperation(cm.eop)
	c:RegisterEffect(ee3)
	--to hand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetTarget(cm.tg)
	e1:SetOperation(cm.op)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(cm.spcon)
	e1:SetTarget(cm.sptg)
	e1:SetOperation(cm.spop)
	c:RegisterEffect(e1)
end
function cm.incon(e)
	return Card.GetCounter(e:GetHandler(),0x624)>=1
end
function cm.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end
function cm.spfil(c,e,tp)
	return c:IsCanHaveCounter(0x624) and Duel.IsCanAddCounter(c:GetControler(),0x624,1,c) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsType(TYPE_MONSTER)
end
function cm.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsCanRemoveCounter(tp,1,0,0x624,1,REASON_RULE)
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>1
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false)
		and Duel.IsExistingMatchingCard(cm.spfil,tp,LOCATION_HAND,0,1,nil,e,tp)
		and not Duel.IsPlayerAffectedByEffect(tp,59822133) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),2,0,0)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,cm.spfil,tp,LOCATION_HAND,0,1,1,nil,e,tp)
	if #g>0 and c:IsRelateToEffect(e) then
		g:AddCard(c)
		if Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)~=0 then
			local sg=Duel.GetOperatedGroup()
			for tc in aux.Next(sg) do  
				tc:AddCounter(0x624,1)
				Duel.RegisterFlagEffect(tp,60002148,0,0,1)
			end
		end
	end
end
function cm.efil(c,e,tp)
	return c:IsCanHaveCounter(0x624) and Duel.IsCanAddCounter(c:GetControler(),0x624,1,c) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsType(TYPE_MONSTER) and not c:IsCode(m)
end
function cm.etg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(cm.efil,tp,LOCATION_HAND,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function cm.eop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,cm.efil,tp,LOCATION_HAND,0,1,1,nil,e,tp)
	if #g>0 and Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)~=0 then
		local tc=Duel.GetOperatedGroup():GetFirst()
		tc:AddCounter(0x624,1)
		Duel.RegisterFlagEffect(tp,60002148,0,0,1)
	end
end