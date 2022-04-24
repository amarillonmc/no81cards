local m=53799017
local cm=_G["c"..m]
cm.name="缠身的月影 孔斯"
function cm.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddXyzProcedureLevelFree(c,cm.mfilter,cm.xyzcheck,2,2)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,m)
	e1:SetCondition(cm.thcon)
	--e1:SetCost(cm.thcost)
	e1:SetTarget(cm.thtg)
	e1:SetOperation(cm.thop)
	c:RegisterEffect(e1)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_CHAINING)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1,m+500)
	e4:SetCondition(cm.chcon)
	e4:SetOperation(cm.chop)
	c:RegisterEffect(e4)
	local e10=Effect.CreateEffect(c)
	e10:SetType(EFFECT_TYPE_FIELD)
	e10:SetCode(EFFECT_ACTIVATE_COST)
	e10:SetRange(LOCATION_MZONE)
	e10:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e10:SetTargetRange(0,1)
	e10:SetTarget(cm.actarget)
	e10:SetOperation(cm.costop)
	c:RegisterEffect(e10)
	if not cm.khonsu then
		cm.khonsu=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_PHASE_START+PHASE_DRAW)
		ge1:SetOperation(cm.checkop)
		Duel.RegisterEffect(ge1,0)
		cm[0]=Duel.SetOperationInfo
		Duel.SetOperationInfo=function(...)
			local f1,f2=Duel.GetFlagEffect(0,m),Duel.GetFlagEffect(1,m)
			if f1>0 then return cm[0](0,CATEGORY_TOGRAVE,nil,1,1,LOCATION_DECK) end
			if f2>0 then return cm[0](0,CATEGORY_TOGRAVE,nil,1,0,LOCATION_DECK) end
			if f1==0 and f2==0 then return cm[0](...) end
		end
	end
end
function cm.checkop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(function(c)return c:GetActivateEffect()end,0,0xff,0xff,nil)
	local reg=Card.RegisterEffect
	Card.RegisterEffect=function(sc,se,bool)
		if se:IsHasType(EFFECT_TYPE_ACTIVATE) then
			local tg=se:GetTarget()
			if tg then
				se:SetTarget(function(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
					if chkc then return tg(e,tp,eg,ep,ev,re,r,rp,0,chkc) end
					if chk==0 then return tg(e,tp,eg,ep,ev,re,r,rp,chk) end
					tg(e,tp,eg,ep,ev,re,r,rp,chk)
					if Duel.GetFlagEffect(tp,m)>0 then Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK) end
				end)
			else
				se:SetTarget(function(e,tp,eg,ep,ev,re,r,rp,chk)
					if chk==0 then return true end
					if Duel.GetFlagEffect(tp,m)>0 then Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK) end
				end)
			end
		end
		reg(sc,se,bool)
	end
	for tc in aux.Next(g) do
		if tc.initial_effect then
			tc:ReplaceEffect(tc:GetOriginalCode(),0)
		end
	end
	Card.RegisterEffect=reg
	e:Reset()
end
function cm.mfilter(c,xyzc)
	return c:IsXyzType(TYPE_MONSTER) and c:IsXyzLevel(xyzc,7)
end
function cm.xyzcheck(g)
	return g:GetClassCount(Card.GetAttribute)==#g
end
function cm.thcon(e,tp,eg,ep,ev,re,r,rp)
	return rp~=tp and re:IsHasCategory(CATEGORY_TOGRAVE+CATEGORY_DECKDES) and not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED)
end
function cm.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function cm.thfilter(c)
	return bit.band(c:GetType(),0x20004)==0x20004 and c:IsAbleToHand()
end
function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function cm.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,cm.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function cm.chcon(e,tp,eg,ep,ev,re,r,rp)
	return ep==1-tp and re:IsHasType(EFFECT_TYPE_ACTIVATE)
end
function cm.chop(e,tp,eg,ep,ev,re,r,rp)
	local cat=re:GetCategory()
	re:SetCategory(CATEGORY_TOGRAVE)
	local e3=Effect.CreateEffect(e:GetHandler())
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_CHAIN_END)
	e3:SetLabel(cat)
	e3:SetLabelObject(re)
	e3:SetOperation(cm.op)
	Duel.RegisterEffect(e3,tp)
	local g=Group.CreateGroup()
	Duel.ChangeTargetCard(ev,g)
	Duel.ChangeChainOperation(ev,cm.repop)
	Duel.ResetFlagEffect(1-tp,m)
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	local cat,re=e:GetLabel(),e:GetLabelObject()
	re:SetCategory(cat)
	e:Reset()
end
function cm.repop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,m)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,function(c)return c:IsType(TYPE_MONSTER) and c:IsAbleToGrave()end,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoGrave(g,REASON_EFFECT)
	end
end
function cm.actarget(e,te,tp)
	return te:IsHasType(EFFECT_TYPE_ACTIVATE)
end
function cm.costop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFlagEffect(tp,m+500)>0 then return end
	Duel.RegisterFlagEffect(tp,m,RESET_CHAIN,0,1)
	Duel.RegisterFlagEffect(tp,m+500,RESET_PHASE+PHASE_END,0,1)
end
