--梦为完人的理想
local m=43990061
local cm=_G["c"..m]
function cm.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,43990061+EFFECT_COUNT_CODE_OATH)
	e1:SetOperation(c43990061.activate)
	c:RegisterEffect(e1)
	--hand tribute
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetCode(EFFECT_ADD_EXTRA_TRIBUTE)
	e2:SetTarget(aux.TargetBoolFunction(Card.IsFacedown))
	e2:SetTargetRange(LOCATION_ONFIELD,LOCATION_ONFIELD)
	e2:SetValue(POS_FACEUP_ATTACK)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
	e3:SetRange(LOCATION_SZONE)
	e3:SetTargetRange(LOCATION_HAND,0)
	e3:SetTarget(c43990061.dccon)
	e3:SetLabelObject(e2)
	c:RegisterEffect(e3)
	--draw
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(40008717,0))
	e4:SetCategory(CATEGORY_DRAW)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_SUMMON_SUCCESS)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCondition(c43990061.condition)
	e4:SetTarget(c43990061.target)
	e4:SetOperation(c43990061.operation)
	c:RegisterEffect(e4)
	local e5=e4:Clone()
	e5:SetCode(EVENT_MSET)
	e5:SetLabelObject(e4)
	c:RegisterEffect(e5)
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_FIELD)
	e6:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_IGNORE_RANGE)
	e6:SetRange(LOCATION_SZONE)
	e6:SetCode(EFFECT_MATERIAL_CHECK)
	e6:SetValue(c43990061.valcheck)
	e6:SetLabelObject(e5)
	c:RegisterEffect(e6)  

end

function c43990061.valcheck(e,c)
	if c:GetMaterial() then
		e:GetLabelObject():SetLabel(1)
		e:GetLabelObject():GetLabelObject():SetLabel(1)
	else
		e:GetLabelObject():SetLabel(0)
		e:GetLabelObject():GetLabelObject():SetLabel(0)
	end
end
function c43990061.condition(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	return tc:IsSummonType(SUMMON_TYPE_ADVANCE) and tc:IsSetCard(0x3510) and tc:GetSummonPlayer()==tp and e:GetLabel()==1
end
function c43990061.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c43990061.operation(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end


function c43990061.dccon(e,c)
	return c:IsSetCard(0x3510)
end
function c43990061.filter(c)
	return c:IsSetCard(0x3510) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c43990061.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c43990061.filter,tp,LOCATION_DECK,0,nil)
	if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(43990061,0)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg=g:Select(tp,1,1,nil)
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sg)
	end
end
