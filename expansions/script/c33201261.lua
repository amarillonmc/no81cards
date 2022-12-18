--镜装龙契 剑姬萨莉
local m=33201261
local cm=_G["c"..m]
xpcall(function() require("expansions/script/c33201250") end,function() require("script/c33201250") end)
function cm.initial_effect(c)
	VHisc_Dragonk.xyzsm(c,m)	
	--set
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,1))
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,m)
	e1:SetCondition(cm.poscon)
	e1:SetTarget(cm.postg)
	e1:SetOperation(cm.posop)
	c:RegisterEffect(e1)
	--to grave
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,2))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_TOEXTRA)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_DESTROYED)
	e2:SetCountLimit(1,id)
	e2:SetCondition(cm.thcon)
	e2:SetTarget(cm.thtg)
	e2:SetOperation(cm.thop)
	c:RegisterEffect(e2)
end
cm.VHisc_DragonCovenant=true

function cm.poscon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_XYZ)
end
function cm.posfilter(c)
	return c:IsFaceup() and c:IsCanTurnSet()
end
function cm.postg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.posfilter,tp,0,LOCATION_MZONE,1,nil) or Duel.IsExistingMatchingCard(Card.IsFacedown,tp,0,LOCATION_MZONE,1,nil) end
	local g=Duel.GetMatchingGroup(nil,tp,0,LOCATION_MZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_POSITION,g,g:GetCount(),0,0)
end
function cm.posop(e,tp,eg,ep,ev,re,r,rp)
	local g1=Duel.GetMatchingGroup(Card.IsFacedown,tp,0,LOCATION_MZONE,nil)
	local g2=Duel.GetMatchingGroup(cm.posfilter,tp,0,LOCATION_MZONE,nil)
	Duel.ChangePosition(g1,POS_FACEUP_ATTACK,POS_FACEUP_ATTACK,POS_FACEUP_DEFENSE,POS_FACEUP_DEFENSE,true)
	Duel.ChangePosition(g2,POS_FACEDOWN_DEFENSE)
end

function cm.thcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousLocation(LOCATION_ONFIELD)
end
function cm.thft(c)
	return c.VHisc_DragonCovenant and c:IsAbleToHand()
end
function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.thft,tp,LOCATION_DECK,0,1,nil) and e:GetHandler():IsAbleToExtra() end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_TOEXTRA,e:GetHandler(),1,0,0)
end
function cm.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,cm.thft,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 and Duel.SendtoHand(g,nil,REASON_EFFECT)>0 then
		Duel.Hint(24,0,aux.Stringid(m,3))
		Duel.ConfirmCards(1-tp,g)
		if c:IsRelateToEffect(e) then Duel.SendtoDeck(c,nil,SEQ_DECKSHUFFLE,REASON_EFFECT) end
	end
end
