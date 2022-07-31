local m=31400140
local cm=_G["c"..m]
cm.name="龙仪巧-绮罗星列流星群"
if not cm.hack then
	cm.hack=true
	cm.AddDrytronSpSummonEffect=aux.AddDrytronSpSummonEffect
	aux.AddDrytronSpSummonEffect=function(c,func)
		local e1=cm.AddDrytronSpSummonEffect(c,func)
		local e2=e1:Clone()
		e2:SetType(EFFECT_TYPE_QUICK_O)
		e2:SetCode(EVENT_FREE_CHAIN)
		e2:SetCondition(cm.con_quick)
		e2:SetLabelObject(e1)
		e2:SetCountLimit(1,c:GetCode())
		c:RegisterEffect(e2)		
		e1:SetCondition(cm.con_ig)
		return e1
	end
end
function cm.initial_effect(c)
	c:EnableReviveLimit()
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_MATERIAL_CHECK)
	e0:SetValue(cm.valcheck)
	c:RegisterEffect(e0)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(aux.indoval)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOGRAVE)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_RELEASE)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e2:SetTarget(cm.tgtg)
	e2:SetOperation(cm.tgop)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetCode(m)
	e3:SetCondition(cm.con)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(1,0)
	e3:SetLabelObject(e0)
	c:RegisterEffect(e3)
end
function cm.con_ig(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsPlayerAffectedByEffect(tp,m)
end
function cm.con_quick(e,tp,eg,ep,ev,re,r,rp)
	e:SetDescription(e:GetLabelObject():GetDescription())
	e:SetCategory(e:GetLabelObject():GetCategory())
	return Duel.IsPlayerAffectedByEffect(tp,m)
end
function cm.con(e)
	return e:GetLabelObject():GetLabel()==1
end
function cm.lvfilter(c,rc)
	return c:GetRitualLevel(rc)>0
end
function cm.valcheck(e,c)
	local mg=c:GetMaterial()
	local fg=mg:Filter(cm.lvfilter,nil,c)
	if #fg>0 and fg:GetSum(Card.GetRitualLevel,c)<=2 then
		e:SetLabel(1)
	else
		e:SetLabel(0)
	end
end
function cm.tgfilter(c)
	return c:IsSetCard(0x154) and c:IsType(TYPE_MONSTER) and c:IsAbleToGrave()
end
function cm.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.tgfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function cm.tgop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,cm.tgfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g then
		Duel.SendtoGrave(g,REASON_EFFECT)
	end
end