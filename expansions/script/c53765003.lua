if not require and dofile then function require(str) return dofile(str..".lua") end end
if not pcall(function() require("expansions/script/c53702500") end) then require("script/c53702500") end
local m=53765003
local cm=_G["c"..m]
cm.name="枷狱三重身 刻耳柏洛斯"
cm.Snnm_Ef_Rst=true
cm.AD_Ht=true
function cm.initial_effect(c)
	SNNM.AllEffectReset(c)
	local e1,e1_1,e2,e3=SNNM.ActivatedAsSpellorTrap(c,0x20004,LOCATION_HAND)
	e1:SetDescription(aux.Stringid(m,0))
	SNNM.HelltakerActivate(c,m)
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(m,3))
	e4:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e4:SetCode(EVENT_SUMMON_SUCCESS)
	e4:SetTarget(cm.srtg)
	e4:SetOperation(cm.srop)
	c:RegisterEffect(e4)
	local e5=e4:Clone()
	e5:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e5)
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(m,4))
	e6:SetCategory(CATEGORY_TOHAND+CATEGORY_DESTROY)
	e6:SetType(EFFECT_TYPE_IGNITION)
	e6:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e6:SetRange(LOCATION_GRAVE)
	e6:SetCost(cm.thcost)
	e6:SetTarget(cm.thtg)
	e6:SetOperation(cm.thop)
	c:RegisterEffect(e6)
	if not cm.global_check then
		cm.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_TO_GRAVE)
		ge1:SetOperation(cm.checkop)
		Duel.RegisterEffect(ge1,0)
	end
	SNNM.ActivatedAsSpellorTrapCheck(c)
end
function cm.checkop(e,tp,eg,ep,ev,re,r,rp)
	for tc in aux.Next(eg) do
		local rc=tc:GetReasonCard()
		local re2=tc:GetReasonEffect()
		if not rc and re2 then rc=re2:GetHandler() end
		if rc and rc:IsLocation(LOCATION_ONFIELD) then
			rc:CreateRelation(tc,RESET_EVENT+0x1fc0000)
			local e1=Effect.CreateEffect(tc)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(m)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			e1:SetLabelObject(rc)
			tc:RegisterEffect(e1,true)
		end
	end
end
function cm.filter(c)
	return c:IsCode(m) and c:IsAbleToHand()
end
function cm.fselect(g,ct)
	return g:FilterCount(aux.NOT(Card.IsLocation),nil,LOCATION_DECK)<=ct
end
function cm.srtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local ct=e:GetHandler():GetFlagEffectLabel(m+50) or 0
	local g=Group.__add(Duel.GetMatchingGroup(Card.IsFaceupEx,tp,0xff,0,nil),Duel.GetOverlayGroup(tp,1,0)):Filter(cm.filter,nil)
	if chk==0 then return g:CheckSubGroup(cm.fselect,1,2,ct) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,0xff)
end
function cm.srop(e,tp,eg,ep,ev,re,r,rp)
	local ct=e:GetHandler():GetFlagEffectLabel(m+50) or 0
	local g=Group.__add(Duel.GetMatchingGroup(Card.IsFaceupEx,tp,0xff,0,nil),Duel.GetOverlayGroup(tp,1,0)):Filter(cm.filter,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local sg=g:SelectSubGroup(tp,cm.fselect,false,1,2,ct)
	if sg then
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sg)
	end
end
function cm.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
	e:GetHandler():CreateEffectRelation(e)
end
function cm.thfilter(c)
	return c:IsSetCard(0xc530) and c:IsLevelAbove(6) and c:IsAbleToHand()
end
function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and cm.thfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(cm.thfilter,tp,LOCATION_GRAVE,0,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,cm.thfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function cm.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if not tc:IsRelateToEffect(e) then return end
	local le={tc:IsHasEffect(m)}
	local rc=nil
	for _,v in pairs(le) do rc=v:GetLabelObject() end
	local ct=Duel.SendtoHand(tc,nil,REASON_EFFECT)
	Duel.ConfirmCards(1-tp,tc)
	if ct>0 and tc:IsLocation(LOCATION_HAND) and rc and rc:IsRelateToCard(tc) and Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_ONFIELD,nil):IsContains(rc) and c:IsRelateToEffect(e) and c:IsAbleToDeck() then
		Duel.BreakEffect()
		if Duel.SendtoDeck(c,tp,2,REASON_EFFECT)~=0 and c:IsLocation(LOCATION_DECK) then Duel.Destroy(rc,REASON_EFFECT) end
	end
end
