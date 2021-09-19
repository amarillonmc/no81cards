--Re:CREATORS 筑城院真鉴
local m=33403520
local cm=_G["c"..m]
Duel.LoadScript("c33400000.lua")
function cm.initial_effect(c)
	XY.magane(c)
	c:SetUniqueOnField(1,0,m)   
  --change effect
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e1:SetCode(EVENT_CHAINING)
	e1:SetRange(LOCATION_MZONE+LOCATION_HAND)
	e1:SetCountLimit(1,m)
	e1:SetCondition(cm.chcon)
	e1:SetOperation(cm.chop)
	c:RegisterEffect(e1)
--
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,1))
	e2:SetCategory(CATEGORY_TOGRAVE)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_CHAIN_NEGATED)
	e2:SetRange(LOCATION_MZONE+LOCATION_HAND)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,m+10000)
	e2:SetCondition(cm.condition)
	e2:SetTarget(cm.sptg)
	e2:SetOperation(cm.spop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_CHAIN_DISABLED)
	c:RegisterEffect(e3)
 --draw
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(m,1))
	e4:SetCategory(CATEGORY_TOGRAVE)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_PHASE+PHASE_END)
	e4:SetRange(LOCATION_MZONE+LOCATION_HAND)
	e4:SetCountLimit(1,m+20000)
	e4:SetTarget(cm.sptg2)
	e4:SetOperation(cm.spop2)
	c:RegisterEffect(e4)
end
function cm.chcon(e,tp,eg,ep,ev,re,r,rp)
	local ct=Duel.GetCurrentChain()
	if ct<2 then return end
	local te,p=Duel.GetChainInfo(ct-1,CHAININFO_TRIGGERING_EFFECT,CHAININFO_TRIGGERING_PLAYER)
	return te and te:GetHandler():IsSetCard(0x6349) and p==tp and rp==1-tp
end
function cm.chop(e,tp,eg,ep,ev,re,r,rp)
	local g=Group.CreateGroup()
	Duel.ChangeTargetCard(ev,g)
	Duel.ChangeChainOperation(ev,cm.repop)
	if e:GetHandler():IsLocation(LOCATION_HAND) then Duel.SendtoGrave(e:GetHandler(),REASON_EFFECT)end
end
function cm.filter1(c)
	return c:IsSetCard(0x6349) and  c:IsAbleToHand()
end
function cm.repop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(1-tp,cm.filter1,1-tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end

function cm.condition(e,tp,eg,ep,ev,re,r,rp)
	return  re:GetHandler():IsSetCard(0x6349)
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(XY.maganeckfilter10,tp,LOCATION_GRAVE,0,1,nil,tp) end
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	 if not  Duel.IsExistingMatchingCard(XY.maganeckfilter10,tp,LOCATION_GRAVE,0,1,nil,tp) then return end
   local c=e:GetHandler()
   Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(33403530,1))
   local g=Duel.SelectMatchingCard(tp,XY.maganeckfilter10,tp,LOCATION_GRAVE,0,1,1,nil,tp)
   if g:GetCount()>0 then
	local tc=g:GetFirst()
	if tc:IsCode(33403521)  then
	  XY.maganere1(e,tp,eg,ep,ev,re,r,rp)
	end
	if tc:IsCode(33403522)  then
	 XY.maganere2(e,tp,eg,ep,ev,re,r,rp)
	end
	if tc:IsCode(33403523) and Duel.IsExistingMatchingCard(Card.IsFaceup,tp,0,LOCATION_ONFIELD,1,nil) then
	XY.maganere3(e,tp,eg,ep,ev,re,r,rp)
	end
	if tc:IsCode(33403524) and Duel.IsPlayerCanDraw(tp,3) then
	XY.maganere4(e,tp,eg,ep,ev,re,r,rp)
	end
	if tc:IsCode(33403525) and (Duel.IsExistingMatchingCard(Card.IsAbleToChangeControler,tp,0,LOCATION_MZONE,1,nil) or Duel.GetLocationCount(1-tp,LOCATION_MZONE)==0) then
	 XY.maganere5(e,tp,eg,ep,ev,re,r,rp)
	end
	if tc:IsCode(33403526) and Duel.IsPlayerCanDraw(tp,1) then
	XY.maganere6(e,tp,eg,ep,ev,re,r,rp)
	end
	if tc:IsCode(33403527) and Duel.IsExistingMatchingCard(XY.maganethfilter4,tp,LOCATION_GRAVE,0,1,nil) then
	 XY.maganere7(e,tp,eg,ep,ev,re,r,rp)
	end
	if tc:IsCode(33403528)  then
	XY.maganere8(e,tp,eg,ep,ev,re,r,rp)
	end
	cm1=Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)
	cm2=Duel.GetFieldGroupCount(tp,0,LOCATION_DECK)
	if tc:IsCode(33403529) and cm1>=4 and  cm2>=4 and Duel.IsPlayerCanDraw(tp,1) then
	 XY.maganere9(e,tp,eg,ep,ev,re,r,rp)
	end
	if tc:IsCode(33403530)  then
	 XY.maganere10(e,tp,eg,ep,ev,re,r,rp)
	end  
   end 
 if e:GetHandler():IsLocation(LOCATION_HAND) then Duel.SendtoGrave(e:GetHandler(),REASON_EFFECT)end
end

function cm.sptg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(XY.maganethfilter0,tp,LOCATION_GRAVE,0,1,nil,tp) end
end
function cm.spop2(e,tp,eg,ep,ev,re,r,rp)
	 if not  Duel.IsExistingMatchingCard(XY.maganethfilter0,tp,LOCATION_GRAVE,0,1,nil,tp) then return end
   local c=e:GetHandler()
   Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(33403530,1))
   local g=Duel.SelectMatchingCard(tp,XY.maganethfilter0,tp,LOCATION_GRAVE,0,1,1,nil,tp)
   if g:GetCount()>0 then
	local tc=g:GetFirst()
	if tc:IsCode(33403521)  then
	  XY.maganere1(e,tp,eg,ep,ev,re,r,rp)
	end
	if tc:IsCode(33403522)  then
	 XY.maganere2(e,tp,eg,ep,ev,re,r,rp)
	end
	if tc:IsCode(33403523) and Duel.IsExistingMatchingCard(Card.IsFaceup,tp,0,LOCATION_ONFIELD,1,nil) then
	XY.maganere3(e,tp,eg,ep,ev,re,r,rp)
	end
	if tc:IsCode(33403524) and Duel.IsPlayerCanDraw(tp,3) then
	XY.maganere4(e,tp,eg,ep,ev,re,r,rp)
	end
	if tc:IsCode(33403525) and (Duel.IsExistingMatchingCard(Card.IsAbleToChangeControler,tp,0,LOCATION_MZONE,1,nil) or Duel.GetLocationCount(1-tp,LOCATION_MZONE)==0) then
	 XY.maganere5(e,tp,eg,ep,ev,re,r,rp)
	end
	if tc:IsCode(33403526) and Duel.IsPlayerCanDraw(tp,1) then
	XY.maganere6(e,tp,eg,ep,ev,re,r,rp)
	end
	if tc:IsCode(33403527) and Duel.IsExistingMatchingCard(XY.maganethfilter4,tp,LOCATION_GRAVE,0,1,nil) then
	 XY.maganere7(e,tp,eg,ep,ev,re,r,rp)
	end
	if tc:IsCode(33403528)  then
	XY.maganere8(e,tp,eg,ep,ev,re,r,rp)
	end
	cm1=Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)
	cm2=Duel.GetFieldGroupCount(tp,0,LOCATION_DECK)
	if tc:IsCode(33403529) and cm1>=4 and  cm2>=4 and Duel.IsPlayerCanDraw(tp,1) then
	 XY.maganere9(e,tp,eg,ep,ev,re,r,rp)
	end
	if tc:IsCode(33403530)  then
	 XY.maganere10(e,tp,eg,ep,ev,re,r,rp)
	end  
   end 
 if e:GetHandler():IsLocation(LOCATION_HAND) then Duel.SendtoGrave(e:GetHandler(),REASON_EFFECT)end
end








