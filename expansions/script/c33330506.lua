--末 氏 空 骨  再 笙
local m=33330506
local cm=_G["c"..m]
function cm.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,nil,2,2,cm.lcheck)
	c:EnableReviveLimit()
 --atkup
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,m)
	e1:SetCost(cm.cost)
	e1:SetTarget(cm.tg)
	e1:SetOperation(cm.spop)
	c:RegisterEffect(e1)
--banish extra
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,1))
	e2:SetCategory(CATEGORY_REMOVE)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetCountLimit(1)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCost(cm.excost)
	e2:SetTarget(cm.extg)
	e2:SetOperation(cm.exop)
	c:RegisterEffect(e2)
end
function cm.lcheck(g)
	return g:IsExists(Card.IsLevel,1,nil,1)
end
--特 招 衍 生 物 
function cm.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetMZoneCount(tp,e:GetHandler())>0 and Duel.IsPlayerCanSpecialSummonMonster(tp,33330500,0,0x4011,-2,0,1,RACE_ZOMBIE,ATTRIBUTE_LIGHT) end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<1 then return end
	if Duel.IsPlayerCanSpecialSummonMonster(tp,33330500,0,0x4011,-2,0,1,RACE_ZOMBIE,ATTRIBUTE_LIGHT) then
		local ct=1
		local atk=Duel.GetFieldGroupCount(e:GetHandler():GetControler(),LOCATION_REMOVED,0)*300
			local token=Duel.CreateToken(tp,33330500)
			Duel.SpecialSummonStep(token,0,tp,tp,false,false,POS_FACEUP)
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_SET_BASE_ATTACK)
			e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
			e1:SetRange(LOCATION_MZONE)
			e1:SetValue(atk)
			token:RegisterEffect(e1,true)
			Duel.SpecialSummonComplete()
	end
	
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToRemoveAsCost() end
	if Duel.Remove(c,POS_FACEUP,REASON_COST+REASON_TEMPORARY)~=0 then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_PHASE+PHASE_STANDBY)
		e1:SetReset(RESET_PHASE+PHASE_STANDBY+RESET_SELF_TURN)
		e1:SetLabelObject(c)
		e1:SetCountLimit(1)
		e1:SetOperation(cm.retop)
		 e1:SetCondition(cm.retcon)
		Duel.RegisterEffect(e1,tp)
	end
end
function cm.retcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end
function cm.retop(e,tp,eg,ep,ev,re,r,rp)
	Duel.ReturnToField(e:GetLabelObject())
end
--除 外
function cm.excost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToRemoveAsCost,tp,LOCATION_GRAVE+LOCATION_ONFIELD,0,3,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,Card.IsAbleToRemoveAsCost,tp,LOCATION_GRAVE+LOCATION_ONFIELD,0,3,3,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function cm.extg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,0,LOCATION_EXTRA,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,1-tp,LOCATION_EXTRA)
end
function cm.exop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetFieldGroup(tp,0,LOCATION_EXTRA)
	Duel.ConfirmCards(tp,g)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local sg=g:FilterSelect(tp,Card.IsAbleToRemove,1,1,nil)
	Duel.Remove(sg,POS_FACEUP,REASON_EFFECT)
end

