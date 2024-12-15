--动力编码龙
local cm,m=GetID()
function cm.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,nil,2)
	c:EnableReviveLimit()
	--destroy
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_DESTROY+CATEGORY_DAMAGE)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(cm.descon)
	e3:SetTarget(cm.destg)
	e3:SetOperation(cm.desop)
	c:RegisterEffect(e3)
	--material check
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e5:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e5:SetCode(EVENT_SPSUMMON_SUCCESS)
	e5:SetCondition(cm.matcon)
	e5:SetOperation(cm.matop)
	c:RegisterEffect(e5)
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_SINGLE)
	e6:SetCode(EFFECT_MATERIAL_CHECK)
	e6:SetValue(cm.valcheck)
	e6:SetLabelObject(e5)
	c:RegisterEffect(e6)
end
function cm.descon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetFlagEffectLabel(m+10000) and e:GetHandler():GetFlagEffectLabel(m+10000)>0
end
function cm.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD,1,nil) and c:GetFlagEffect(m)<c:GetFlagEffectLabel(m+10000) end
	c:RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD,0,1)
	local g=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,1000)
end
function cm.desop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD,1,1,nil)
	if #g>0 and Duel.Remove(g,POS_FACEUP,REASON_EFFECT)~=0 then
		Duel.Damage(1-tp,1000,REASON_EFFECT)
	end
end
function cm.matcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK) and e:GetLabel()>0
end
function cm.matop(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():RegisterFlagEffect(m+10000,RESET_EVENT+RESETS_STANDARD,0,1,e:GetLabel())
end
function cm.valcheck(e,c)
	local g=c:GetMaterial()
	local ct=0
	for i=1,1000 do
		if g:CheckWithSumEqual(aux.GetLinkCount,i,#g,#g) then ct=ct+1 end
	end
	e:GetLabelObject():SetLabel(math.floor(ct/2))
end