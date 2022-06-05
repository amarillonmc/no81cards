--鸢一折纸 浴场
local m=33400408
local cm=_G["c"..m]
function cm.initial_effect(c)
   --xyz summon
	aux.AddXyzProcedure(c,cm.xyzfilter,4,2)
	c:EnableReviveLimit()
	 --to hand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1,m)
	e1:SetCondition(cm.thcon)
	e1:SetCost(cm.thcost)
	e1:SetTarget(cm.thtg)
	e1:SetOperation(cm.thop)
	c:RegisterEffect(e1)
	--to grave
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,1))
	e2:SetCategory(CATEGORY_TOGRAVE+CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCountLimit(1,m)
	e2:SetCondition(cm.thcon)
	e2:SetCost(cm.thcost)
	e2:SetTarget(cm.tgtg)
	e2:SetOperation(cm.tgop)
	c:RegisterEffect(e2)
   --Gains Effect
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,0))
	e3:SetCategory(CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_XMATERIAL+EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetCountLimit(1,m+10000)
	e3:SetCondition(cm.efcon)
	e3:SetTarget(cm.eftg)
	e3:SetOperation(cm.efop)
	c:RegisterEffect(e3)
end
function cm.xyzfilter(c)
	return c:IsSetCard(0x5342) 
end
function cm.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_XYZ)
end
function cm.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local ft=0
	if e:GetHandler():GetFlagEffect(33401301)>0 then ft=1 end
	if chk==0 then return  ((ft==1) or e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST)) end   
	if ft==0 then 
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
	end
end
function cm.thfilter1(c)
	return (c:IsSetCard(0x341)or c:IsSetCard(0xc343)) and c:IsSetCard(0x95) and c:IsType(TYPE_SPELL) and c:IsAbleToHand()
end
function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.thfilter1,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE)
end
function cm.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,cm.thfilter1,tp,LOCATION_GRAVE,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function cm.tgfilter1(c)
	return (c:IsSetCard(0x341)or c:IsSetCard(0xc343)) and c:IsSetCard(0x95) and c:IsType(TYPE_SPELL) and c:IsAbleToGrave()
end
function cm.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.tgfilter1,tp,LOCATION_DECK,0,1,nil)  end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function cm.tgop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,cm.tgfilter1,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoGrave(g,nil,REASON_EFFECT)
		if Duel.IsPlayerCanDraw(tp,1) then
			if Duel.SelectYesNo(tp,aux.Stringid(m,2)) then 
				Duel.Draw(tp,1,REASON_EFFECT)
			end
		end
	end
end

function cm.efcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return  c:IsSummonType(SUMMON_TYPE_XYZ) and c:IsSetCard(0xc343)
end
function cm.eftg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.thfilter3,tp,LOCATION_GRAVE,0,1,nil) end
   Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE)
end
function cm.efop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,cm.thfilter3,tp,LOCATION_GRAVE,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetTarget(cm.splimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function cm.thfilter3(c)
	return c:IsType(TYPE_SPELL) and c:IsSetCard(0x95) and c:IsAbleToHand()
end
function cm.splimit(e,c)
	return not c:IsSetCard(0xc343)
end