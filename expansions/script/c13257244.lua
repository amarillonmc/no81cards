--宇宙战争机器-光炮核
local m=13257244
local cm=_G["c"..m]
xpcall(function() require("expansions/script/tama") end,function() require("script/tama") end)
function cm.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetRange(LOCATION_SZONE)
	e1:SetCountLimit(1)
	e1:SetCondition(cm.condition)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(LOCATION_SZONE,LOCATION_SZONE)
	e2:SetTarget(cm.eftg)
	e2:SetLabelObject(e1)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_DESTROYED)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCondition(cm.drcon)
	e3:SetOperation(cm.drop)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
	e4:SetRange(LOCATION_MZONE)
	e4:SetTargetRange(LOCATION_SZONE,LOCATION_SZONE)
	e4:SetTarget(cm.eftg1)
	e4:SetLabelObject(e3)
	c:RegisterEffect(e4)
	--deck equip
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(m,1))
	e5:SetCategory(CATEGORY_EQUIP)
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetRange(LOCATION_MZONE)
	e5:SetTarget(cm.eqtg)
	e5:SetOperation(cm.eqop)
	c:RegisterEffect(e5)
	
	eflist={{"deck_equip",e5},{"core_level",1}}
	cm[c]=eflist
end
function cm.condition(e,tp,eg,ep,ev,re,r,rp)
	return re:GetHandler()==e:GetHandler()
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local ftg=re:GetTarget()
	if chkc then return ftg(e,tp,eg,ep,ev,re,r,rp,chk,chkc) end
	if chk==0 then return not ftg or ftg(e,tp,eg,ep,ev,re,r,rp,chk) end
	if re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then
		e:SetProperty(EFFECT_FLAG_CARD_TARGET)
	end
	if ftg then
		ftg(e,tp,eg,ep,ev,re,r,rp,chk)
	end
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local fop=re:GetOperation()
	fop(e,tp,eg,ep,ev,re,r,rp)
end
function cm.eftg(e,c)
	return e:GetHandler():GetEquipGroup():IsContains(c) and c:IsSetCard(0x9354)
end
function cm.drcon(e,tp,eg,ep,ev,re,r,rp)
	if bit.band(r,REASON_EFFECT)<=0 then return false end
	return re:GetHandler()==e:GetHandler()
end
function cm.drop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,e:GetHandler():GetCode())
	Duel.Draw(tp,1,REASON_EFFECT)
end
function cm.eftg1(e,c)
	return e:GetHandler():GetEquipGroup():IsContains(c) and c:IsSetCard(0x354)
end
function cm.eqfilter(c,ec)
	return c:IsSetCard(0x354) and c:IsType(TYPE_MONSTER) and c:CheckEquipTarget(ec)
end
function cm.eqtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingMatchingCard(cm.eqfilter,tp,LOCATION_EXTRA,0,1,nil,e:GetHandler()) end
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,nil,1,tp,LOCATION_EXTRA)
end
function cm.eqop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 or c:IsFacedown() or not c:IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	local g=Duel.SelectMatchingCard(tp,cm.eqfilter,tp,LOCATION_EXTRA,0,1,1,nil,c)
	local tc=g:GetFirst()
	if tc then
		Duel.Equip(tp,tc,c)
	end
end
