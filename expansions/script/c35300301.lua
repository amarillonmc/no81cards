--伪装胚胎 异形一号
local m=35300301
local cm=_G["c"..m]
function cm.initial_effect(c)
	--equip
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,m)
	e1:SetTarget(cm.eqtg)
	e1:SetOperation(cm.eqop)
	c:RegisterEffect(e1)  
	--Atk,def
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_EQUIP)
	e2:SetCode(EFFECT_SET_ATTACK)
	e2:SetValue(0)
	c:RegisterEffect(e2)
	local e4=e2:Clone()
	e4:SetCode(EFFECT_SET_DEFENSE)
	c:RegisterEffect(e4)
	local e5=e2:Clone()
	e5:SetCode(EFFECT_CHANGE_RACE)
	e5:SetValue(RACE_REPTILE)
	c:RegisterEffect(e5)
	--negate
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_EQUIP)
	e3:SetCode(EFFECT_DISABLE)
	c:RegisterEffect(e3)
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,1))
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_LEAVE_FIELD)
	e3:SetCountLimit(1,m+1)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e3:SetTarget(cm.thtg2)
	e3:SetOperation(cm.thop2)
	c:RegisterEffect(e3)
	--cannot release
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_RELEASE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetRange(LOCATION_SZONE)
	e1:SetTargetRange(0,1)
	e1:SetTarget(cm.rellimit)
	c:RegisterEffect(e1)
	--cannot be material
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_EQUIP)
	e6:SetCode(EFFECT_CANNOT_BE_FUSION_MATERIAL)
	e6:SetValue(cm.splimit)
	c:RegisterEffect(e6)
	local e4=e6:Clone()
	e4:SetCode(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL)
	c:RegisterEffect(e4)
	local e5=e6:Clone()
	e5:SetCode(EFFECT_CANNOT_BE_XYZ_MATERIAL)
	c:RegisterEffect(e5)
	local e7=e6:Clone()
	e7:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
	c:RegisterEffect(e7)
end
function cm.qfilter(c)
	return c:IsFaceup()
end
function cm.eqtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingMatchingCard(cm.qfilter,1-tp,LOCATION_MZONE,0,1,e:GetHandler()) end
end
function cm.eqop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then
		Duel.SendtoGrave(c,REASON_EFFECT)
		return
	end
	local tc=Duel.SelectMatchingCard(tp,cm.qfilter,1-tp,LOCATION_MZONE,0,1,1,e:GetHandler()):GetFirst()
	Duel.Equip(tp,c,tc,true)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_EQUIP_LIMIT)
	e1:SetReset(RESET_EVENT+0x1fe0000)
	e1:SetValue(cm.eqlimit)
	c:RegisterEffect(e1)
end
function cm.eqlimit(e,c)
	return c:IsFaceup()
end

function cm.thfilter2(c)
	return c:IsSetCard(0x3ac3) and c:IsAbleToHand() and c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function cm.thtg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.thfilter2,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function cm.thop2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,cm.thfilter2,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function cm.rellimit(e,c,tp,sumtp)
	return c==e:GetHandler():GetEquipTarget()
end

function cm.splimit(e,c)
	if not c then return false end
	return not c:IsSetCard(0x3ac3)
end