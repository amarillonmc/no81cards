--他人格 ～色欲～
local cm,m=GetID()
if not pcall(function() require("expansions/script/c130006111") end) then require("script/c130006111") end
cm.AlterEgo=true
function cm.initial_effect(c)
	ae.initial(c)
	--destroy
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_SZONE)
	e1:SetCondition(function(e) return e:GetHandler():GetFlagEffect(m)>0 end)
	e1:SetCountLimit(1)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetTarget(cm.destg)
	e1:SetOperation(cm.desop)
	c:RegisterEffect(e1)
	--negate
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_NEGATE+CATEGORY_SPECIAL_SUMMON+CATEGORY_SEARCH+CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,m)
	e2:SetCondition(cm.discon)
	e2:SetTarget(cm.distg)
	e2:SetOperation(cm.disop)
	c:RegisterEffect(e2)
end
function cm.mfilter(c)
	return (bit.band(c:GetOriginalType(),TYPE_MONSTER)~=0 and c:IsFaceup()) or (c:IsLocation(LOCATION_MZONE) and c:IsFacedown())
end
function cm.pfilter1(c)
	return bit.band(c:GetOriginalType(),TYPE_PENDULUM)~=0 and c:IsFaceup()
end
function cm.nspfilter(c,tp)
	return c:IsFaceup() and not Duel.IsPlayerCanSpecialSummon(tp,0,POS_FACEDOWN_DEFENSE,tp,c)
end
function cm.nsfilter(c,tp)
	return c:IsFaceup() and not c:IsSSetable(true)
end
function cm.fselect(g,tp)
	local g1=g:Filter(cm.mfilter,nil)
	local pg1=g1:Filter(cm.pfilter1,nil)
	local npg1=Group.__sub(g1,pg1)
	local g2=Group.__sub(g,g1)
	local fc=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local pfc=Duel.GetLocationCountFromEx(tp,tp,nil,TYPE_PENDULUM)
	local xfc=Duel.GetLocationCountFromEx(tp,tp,nil,TYPE_XYZ)
	if #g1>0 and (not Duel.IsPlayerCanSpecialSummon(tp) or g1:IsExists(cm.nspfilter,1,nil,tp) or #npg1>fc or #pg1>pfc or #g1>xfc) then return false end
	if #g2>0 and (not Duel.IsPlayerCanSSet(tp) or g2:IsExists(cm.nspfilter,1,nil,tp) or #g2>Duel.GetLocationCount(tp,LOCATION_SZONE)) then return false end
	return true
end
function cm.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	local tg=Duel.GetMatchingGroup(Card.IsCanBeEffectTarget,tp,0,LOCATION_ONFIELD,nil,e)
	if chk==0 then return tg:CheckSubGroup(cm.fselect,2,2,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=tg:SelectSubGroup(tp,cm.fselect,false,2,2,tp)
	Duel.SetTargetCard(g)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,2,0,0)
	if g:IsExists(cm.mfilter,1,nil) then
		e:SetCategory(CATEGORY_DESTROY+CATEGORY_SPECIAL_SUMMON+CATEGORY_GRAVE_SPSUMMON)
	else
		e:SetCategory(CATEGORY_DESTROY)
	end
end
function cm.pfilter(c)
	return not ((c:IsLocation(LOCATION_HAND+LOCATION_DECK) or c:IsLocation(LOCATION_REMOVED) and c:IsFacedown())) and aux.NecroValleyFilter()(c)
end
function cm.msfilter(c,e,tp)
	return c:IsType(TYPE_MONSTER) and (not c:IsLocation(LOCATION_EXTRA) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 or c:IsLocation(LOCATION_EXTRA) and c:IsFaceup() and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEDOWN_DEFENSE)
end
function cm.ssfilter(c)
	return (c:IsType(TYPE_FIELD) or Duel.GetLocationCount(tp,LOCATION_SZONE)>0) and c:IsSSetable()
end
function cm.desop(e,tp,eg,ep,ev,re,r,rp)
	local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if Duel.Destroy(tg,REASON_EFFECT)>0 then
		local og=Duel.GetOperatedGroup():Filter(cm.pfilter,nil)
		local mg=og:Filter(cm.msfilter,nil,e,tp)
		local sg=og:Filter(cm.ssfilter,nil)
		if #mg>0 or #sg>0 then Duel.BreakEffect() end
		if #mg>0 then
			Duel.SpecialSummon(mg,0,tp,tp,false,false,POS_FACEDOWN_DEFENSE)
			Duel.ConfirmCards(1-tp,mg)
		end
		if #sg>0 then
			Duel.SSet(tp,mg)
		end
	end
end
function cm.discon(e,tp,eg,ep,ev,re,r,rp)
	return rp==1-tp and not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) and Duel.IsChainNegatable(ev)
end
function cm.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,0,LOCATION_DECK)>0 end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
end
function cm.disop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateActivation(ev) then
		Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_OPERATECARD)
		local g=Duel.SelectMatchingCard(1-tp,Card.IsType,1-tp,LOCATION_DECK,0,1,1,nil,TYPE_MONSTER)
		if g:GetCount()>0 then
			Duel.BreakEffect()
			local tc=g:GetFirst()
			Duel.ConfirmCards(tp,tc)
			if tc:IsAbleToHand() and (not tc:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEDOWN_DEFENSE,tp) or Duel.SelectYesNo(tp,aux.Stringid(m,0))) then
				Duel.SendtoHand(g,tp,REASON_EFFECT)
				Duel.ConfirmCards(1-tp,g)
			elseif tc:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEDOWN_DEFENSE,tp) then
				Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEDOWN_DEFENSE)
			end
		end
	end
end