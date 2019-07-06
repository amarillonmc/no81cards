--十人十色之力
if not pcall(function() require("expansions/script/c10199990") end) then require("script/c10199990") end
local m=33700947
local cm=_G["c"..m]
function cm.initial_effect(c)
	Duel.EnableGlobalFlag(GLOBALFLAG_SELF_TOGRAVE)
	local e1=rsef.ACT(c)
	c:SetUniqueOnField(1,0,m)
	--pub
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_PUBLIC)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTargetRange(LOCATION_HAND,0)
	c:RegisterEffect(e2)
	--tograve
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCode(EFFECT_SELF_TOGRAVE)
	e3:SetCondition(cm.sdcon)
	c:RegisterEffect(e3)
	--halve damage
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_CHANGE_DAMAGE)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetRange(LOCATION_SZONE)
	e4:SetTargetRange(1,0)
	e4:SetCondition(cm.con)
	e4:SetValue(cm.val)
	c:RegisterEffect(e4)
	e4:SetLabel(7)
	local e5=rsef.QO(c,nil,nil,1,"th","tg",LOCATION_SZONE,cm.con2,rscost.reglabel(100),cm.thtg,cm.thop)
	--disable search
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_FIELD)
	e6:SetCode(EFFECT_CANNOT_TO_HAND)
	e6:SetRange(LOCATION_SZONE)
	e6:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e6:SetTargetRange(1,1)
	e6:SetTarget(aux.TargetBoolFunction(Card.IsLocation,LOCATION_DECK+LOCATION_GRAVE))
	e6:SetCondition(cm.con)
	c:RegisterEffect(e6)
	e6:SetLabel(21)
end 
function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsAbleToHand() end  
	if chk==0 then 
		if e:GetLabel()~=100 then return false end
		return Duel.IsExistingMatchingCard(cm.cfilter,tp,LOCATION_HAND,0,1,nil,tp)
	end
	e:SetLabel(0)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local tc=Duel.SelectMatchingCard(tp,cm.cfilter,tp,LOCATION_HAND,0,1,1,nil,tp):GetFirst()
	Duel.SendtoGrave(tc,REASON_COST)
	local f=function(rc,code)
		return rc:IsAbleToHand() and not rc:IsCode(code)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,f,tp,LOCATION_GRAVE,0,1,1,nil,tc:GetCode())
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,tp,LOCATION_GRAVE)
end
function cm.thop(e)
	local tc=rscf.GetTargetCard()
	if tc then Duel.SendtoHand(tc,nil,REASON_EFFECT) end
end
function cm.cfilter(c,tp)
	local f=function(rc,code)
		return rc:IsAbleToHand() and not rc:IsCode(code)
	end
	return c:IsAbleToGraveAsCost() and Duel.IsExistingTarget(f,tp,LOCATION_GRAVE,0,1,nil,c:GetCode())
end
function cm.val(e,re,dam,r,rp,rc)
	return dam/2
end
function cm.sdcon(e)
	local g=Duel.GetFieldGroup(e:GetHandlerPlayer(),LOCATION_HAND,0)
	return #g==0 or g:GetClassCount(Card.GetCode)<#g
end
function cm.con2(e)
	local g=Duel.GetFieldGroup(e:GetHandlerPlayer(),LOCATION_GRAVE,0)
	return g:GetClassCount(Card.GetCode)>=14
end
function cm.con(e)
	local g=Duel.GetFieldGroup(e:GetHandlerPlayer(),LOCATION_GRAVE,0)
	return g:GetClassCount(Card.GetCode)>=e:GetLabel()
end