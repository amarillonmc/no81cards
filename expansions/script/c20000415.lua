--兽机艺•未定形
local m=20000415
local cm=_G["c"..m]
function cm.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
	--cost
	local e2=e1:Clone()
	e2:SetDescription(aux.Stringid(m,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DRAW)
	e2:SetCost(cm.cost)
	c:RegisterEffect(e2)
end
function cm.spfilter1(c,e,tp)
	return c:IsSetCard(0x3fd4) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function cm.costf(c,e,tp)
	return c:IsAbleToDeckAsCost() and Duel.IsExistingMatchingCard(cm.spfilter1,tp,LOCATION_HAND,0,1,c,e,tp) and c:IsSetCard(0x3fd4)
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.costf,tp,LOCATION_HAND,0,1,e:GetHandler(),e,tp) end
	local tc=Duel.SelectMatchingCard(tp,cm.costf,tp,LOCATION_HAND,0,1,1,e:GetHandler(),e,tp)
	Duel.SendtoDeck(tc,nil,2,REASON_COST)
	e:SetLabel(1)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(cm.spfilter1,tp,LOCATION_HAND,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,cm.spfilter1,tp,LOCATION_HAND,0,1,1,nil,e,tp)
	if g:GetCount()>0 and Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)>0 then
		if g:GetFirst():IsSetCard(0xbfd4) then
			cm.Give(c,tp,2,EFFECT_CANNOT_DIRECT_ATTACK,1)
			cm.Give(c,tp,2,EFFECT_CANNOT_SELECT_BATTLE_TARGET,cm.val)
		end 
		if g:GetFirst():IsSetCard(0x7fd4) then
			cm.Give(c,tp,3,EFFECT_SET_ATTACK_FINAL,1000)
			cm.Give(c,tp,3,EFFECT_SET_DEFENSE_FINAL,1000)
		end
		if e:GetLabel()==1 then
			Duel.Draw(tp,1,REASON_EFFECT)
		end
	end
end
function cm.Give(c,tp,n,cod,val)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,n))
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CLIENT_HINT)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(cod)
	e1:SetValue(val)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetTarget(cm.givetarget)
	e2:SetReset(RESET_PHASE+PHASE_END)
	e2:SetLabelObject(e1)
	Duel.RegisterEffect(e2,1-tp)
end
function cm.val(e,c)
	return c:IsFacedown() or not c:IsSetCard(0x3fd4)
end
function cm.givetarget(e,c)
	return c:IsFaceup()
end