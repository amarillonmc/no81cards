local m=53796026
local cm=_G["c"..m]
cm.name="『企画者』"
function cm.initial_effect(c)
	aux.AddXyzProcedure(c,nil,11,2)
	c:EnableReviveLimit()
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,m)
	e1:SetCost(cm.ovcost)
	e1:SetTarget(cm.ovtg)
	e1:SetOperation(cm.ovop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,1))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,m+500)
	e2:SetCost(cm.accost)
	e2:SetTarget(cm.actg)
	e2:SetOperation(cm.acop)
	c:RegisterEffect(e2)
end
function cm.ovcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>0 and Duel.GetFieldGroupCount(tp,0,LOCATION_DECK)>0 end
	Duel.ShuffleDeck(tp)
	Duel.ShuffleDeck(1-tp)
end
function cm.matfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsCanOverlay()
end
function cm.ovtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Group.__add(Duel.GetDecktopGroup(tp,3),Duel.GetDecktopGroup(1-tp,3))
	if chk==0 then return e:GetHandler():IsType(TYPE_XYZ) and Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>=3 and Duel.GetFieldGroupCount(tp,0,LOCATION_DECK)>=3 and Duel.IsExistingMatchingCard(cm.matfilter,tp,LOCATION_DECK,0,1,nil) end
end
function cm.ovop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)<3 or Duel.GetFieldGroupCount(tp,0,LOCATION_DECK)<3 then return end
	Duel.ConfirmDecktop(tp,3)
	Duel.ConfirmDecktop(1-tp,3)
	local g=Group.__add(Duel.GetDecktopGroup(tp,3),Duel.GetDecktopGroup(1-tp,3))
	local sg=g:Filter(cm.matfilter,nil)
	local c=e:GetHandler()
	if #sg==0 or not c:IsRelateToEffect(e) or c:IsImmuneToEffect(e) then
		Duel.ShuffleDeck(tp)
		Duel.ShuffleDeck(1-tp)
		return
	end
	Duel.DisableShuffleCheck()
	Duel.Overlay(c,sg)
	Duel.ShuffleDeck(tp)
	Duel.ShuffleDeck(1-tp)
end
function cm.accost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,8,REASON_COST) end
	local g=e:GetHandler():GetOverlayGroup()
	Duel.SendtoGrave(g,REASON_COST)
end
function cm.setfilter(c)
	return c:IsType(TYPE_CONTINUOUS) and c:IsSSetable()
end
function cm.actg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.setfilter,tp,LOCATION_DECK,0,1,nil) end
end
function cm.acop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local sc=Duel.SelectMatchingCard(tp,cm.setfilter,tp,LOCATION_DECK,0,1,1,nil):GetFirst()
	if sc and Duel.SSet(tp,sc)~=0 then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_TRAP_ACT_IN_SET_TURN)
		e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		sc:RegisterEffect(e1)
	end
end
