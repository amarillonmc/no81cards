--宵神官 迪·扎德
if not require and dofile then function require(str) return dofile(str..".lua") end end
if not pcall(function() require("expansions/script/c53702500") end) then require("script/c53702500") end
function c53771033.initial_effect(c)
	SNNM.Sarcoveil_Sort(c)
	--link summon
	aux.AddLinkProcedure(c,nil,2,2,c53771033.lcheck)
	c:EnableReviveLimit()
	--to hand
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_SPECIAL_SUMMON+CATEGORY_MSET)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,53771033)
	e1:SetCondition(c53771033.thcon)
	e1:SetTarget(c53771033.thtg)
	e1:SetOperation(c53771033.thop)
	c:RegisterEffect(e1)
	--disable
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(53771033,1))
	e2:SetCategory(CATEGORY_DISABLE+CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,53771033+1)
	e2:SetCondition(c53771033.discon)
	e2:SetTarget(c53771033.distg)
	e2:SetOperation(c53771033.disop)
	c:RegisterEffect(e2)
end
function c53771033.mfilter(c)
	return not c:IsStatus(STATUS_SUMMON_TURN+STATUS_SPSUMMON_TURN)
end
function c53771033.lcheck(g,lc)
	return g:IsExists(c53771033.mfilter,1,nil)
end
function c53771033.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end
function c53771033.thfilter(c,e,tp)
	return c:IsCode(53771041) and c:IsAbleToHand() or c:IsRace(RACE_ZOMBIE) and c:IsAttribute(ATTRIBUTE_EARTH) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEDOWN_DEFENSE) and Duel.GetMZoneCount(tp)>0
end
function c53771033.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(c53771033.thfilter,tp,LOCATION_DECK,0,1,nil,e,tp) end
end
function c53771033.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
	local tc=Duel.SelectMatchingCard(tp,c53771033.thfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp):GetFirst()
	if tc:IsCode(53771041) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
	else
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEDOWN_DEFENSE)
		tc:RegisterFlagEffect(53771033,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(53771033,4))
		tc:SetStatus(STATUS_CANNOT_CHANGE_FORM,false)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_FLIPSUMMON_COST)
		e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
		e1:SetLabel(53771033)
		e1:SetLabelObject(tc)
		e1:SetTargetRange(0xff,0xff)
		e1:SetTarget(c53771033.fstg)
		e1:SetCost(SNNM.Sarcoveil_fscost)
		e1:SetOperation(SNNM.Sarcoveil_fsop)
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)
	end
	Duel.ConfirmCards(1-tp,tc)
end
function c53771033.fstg(e,c,tp)
	if c:GetFlagEffect(53771033)==0 or e:GetLabelObject()~=c then return false end
	Sarcoveil_Fsing=c
	return true
end
function c53771033.acfilter(c,g)
	return g:IsContains(c)
end
function c53771033.discon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsStatus(STATUS_BATTLE_DESTROYED) then return false end
	if not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return false end
	local tg=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	local g=c:GetLinkedGroup():Filter(Card.IsControler,nil,tp)
	g:AddCard(c)
	return rp==1-tp and tg and tg:IsExists(c53771033.acfilter,1,nil,g)
end
function c53771033.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function c53771033.disop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateEffect(ev) and re:GetHandler():IsRelateToEffect(re) then
		Duel.Destroy(eg,REASON_EFFECT)
	end
end
