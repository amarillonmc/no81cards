--增幅加速·洛拉米亚
local cm,m,o=GetID()
function cm.initial_effect(c)
	c:EnableCounterPermit(0x624)
	--evolve eff
	local ee1=Effect.CreateEffect(c)
	ee1:SetType(EFFECT_TYPE_SINGLE)
	ee1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	ee1:SetRange(LOCATION_MZONE)
	ee1:SetCode(EFFECT_UPDATE_ATTACK)
	ee1:SetCondition(cm.econ)
	ee1:SetValue(cm.eval)
	c:RegisterEffect(ee1)
	local ee2=ee1:Clone()
	ee2:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(ee2)
	
	local ee3=Effect.CreateEffect(c)
	ee3:SetType(EFFECT_TYPE_FIELD)
	ee3:SetCode(EFFECT_IMMUNE_EFFECT)
	ee3:SetRange(LOCATION_MZONE)
	ee3:SetTargetRange(LOCATION_MZONE,0)
	ee3:SetTarget(cm.indtg)
	ee3:SetValue(cm.efilter)
	c:RegisterEffect(ee3)
	local ee4=Effect.CreateEffect(c)
	ee4:SetType(EFFECT_TYPE_FIELD)
	ee4:SetCode(EFFECT_UPDATE_ATTACK)
	ee4:SetRange(LOCATION_MZONE)
	ee4:SetTargetRange(LOCATION_MZONE,0)
	ee4:SetTarget(cm.indtg)
	ee4:SetValue(cm.eval2)
	c:RegisterEffect(ee4)
	local ee5=ee4:Clone()
	ee5:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(ee5)

	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCost(cm.spcost)
	e1:SetTarget(cm.sptg)
	e1:SetOperation(cm.spop)
	c:RegisterEffect(e1)
	--draw
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DRAW+CATEGORY_COUNTER)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_PLAYER_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EVENT_TO_HAND)
	e2:SetCountLimit(3)
	e2:SetCondition(cm.drcon)
	e2:SetTarget(cm.drtg)
	e2:SetOperation(cm.drop)
	c:RegisterEffect(e2)
end
function cm.econ(e)
	return Card.GetCounter(e:GetHandler(),0x624)>=1
end
function cm.eval(e,c)
	return e:GetHandler():GetCounter(0x624)*400
end
function cm.execon(e)
	return Card.GetCounter(e:GetHandler(),0x624)>=3
end
function cm.indtg(e,c)
	return c:IsRace(RACE_MACHINE) and e:GetHandler()~=c and c:IsFaceup() and cm.execon(e)
end
function cm.efilter(e,te)
	return e:GetHandlerPlayer()~=te:GetOwnerPlayer() and te:IsActivated()
end
function cm.eval2(e,c)
	return e:GetHandler():GetCounter(0x624)*200
end
function cm.spfil1(c)
	return c:IsRace(RACE_MACHINE) and c:IsReleasable()
end
function cm.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local ct=1
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<1 then ct=2 end
	if chk==0 then return Duel.IsExistingMatchingCard(cm.spfil1,tp,LOCATION_MZONE,0,ct,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local g=Duel.SelectMatchingCard(tp,cm.spfil1,tp,LOCATION_MZONE,0,ct,99,nil)
	if Duel.Release(g,REASON_EFFECT) then e:SetLabel(#Duel.GetOperatedGroup()) else return end
end
function cm.spfil2(c,e,tp)
	return c:IsSetCard(0x5622) and c:IsCanBeSpecialSummoned(e,0,tp,true,true)
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>1
		and Duel.IsExistingMatchingCard(cm.spfil2,tp,LOCATION_HAND,0,1,e:GetHandler(),e,tp)
		and not Duel.IsPlayerAffectedByEffect(tp,59822133) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ct=e:GetLabel()
	if ct>=Duel.GetLocationCount(tp,LOCATION_MZONE) then ct=Duel.GetLocationCount(tp,LOCATION_MZONE)-1 end
	if ct==0 or Duel.IsPlayerAffectedByEffect(tp,59822133) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,cm.spfil2,tp,LOCATION_HAND,0,1,ct,c,e,tp)
	if #g>0 then
		g:AddCard(c)
		Duel.SpecialSummon(g,0,tp,tp,true,true,POS_FACEUP)
	end
end
function cm.drfil(c,tp)
	return c:IsControler(tp) and not c:IsReason(REASON_DRAW) and ((c:IsSetCard(0x5622) and c:IsType(TYPE_MONSTER)) or c:IsCode(60001504,60001505))
end
function cm.drcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(cm.drfil,1,nil,tp)
end
function cm.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) and e:GetHandler():IsCanAddCounter(0x624,1) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function cm.drop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	if not c:IsRelateToEffect(e) then return end
	if Duel.Draw(p,d,REASON_EFFECT)~=0 then
		c:AddCounter(0x624,1)
		Duel.RegisterFlagEffect(tp,60002148,0,0,1)
	end
end



