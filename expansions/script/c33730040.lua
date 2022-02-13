-- 键★高潮 冬之花火 / K.E.Y Climax - Fuochi d'Artificio Invernali
--Scripted by: XGlitchy30
local s,id=GetID()

function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,1))
	e1:SetCategory(CATEGORY_TODECK)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_ATTACK_ANNOUNCE)
	e1:SetCondition(s.discon_atk)
	e1:SetCost(s.discost)
	e1:SetTarget(s.distg_atk)
	e1:SetOperation(s.disop_atk)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,0))
	e2:SetCategory(CATEGORY_NEGATE+CATEGORY_TODECK)
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetCode(EVENT_CHAINING)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e2:SetCondition(s.discon)
	e2:SetCost(s.discost)
	e2:SetTarget(s.distg)
	e2:SetOperation(s.disop)
	c:RegisterEffect(e2)
	--recycle
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,2))
	e3:SetCategory(CATEGORY_TODECK)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCost(s.thcost)
	e3:SetTarget(s.thtg)
	e3:SetOperation(s.thop)
	c:RegisterEffect(e3)
end
s.water_aqua_key_monsters = true

function s.discon_atk(e,tp,eg,ep,ev,re,r,rp)
	e:SetLabelObject(Duel.GetAttacker())
	return ep==1-tp
end
function s.discon(e,tp,eg,ep,ev,re,r,rp)
	return ep==1-tp and re:IsActiveType(TYPE_MONSTER) and Duel.IsChainNegatable(ev)
end
function s.discfilter(c)
	return (c:IsLocation(LOCATION_HAND) or c:IsFaceup()) and c:IsSetCard(0x460) and c:IsType(TYPE_MONSTER) and c:IsAttribute(ATTRIBUTE_WATER) and c:IsRace(RACE_AQUA)
		and c:IsAbleToGraveAsCost() and not c:IsStatus(STATUS_BATTLE_DESTROYED)
end
function s.discost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.discfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,s.discfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,1,nil)
	if #g>0 then
		Duel.SendtoGrave(g,REASON_COST)
	end
end
function s.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	local rc=re:GetHandler()
	local rel=rc:IsRelateToEffect(re)
	if chk==0 then return rc:IsAbleToDeck() or not rel and Duel.IsPlayerCanSendtoDeck(tp) end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if rel then
		if re:GetHandler():IsAbleToDeck() and re:GetHandler():IsType(TYPE_MONSTER) then
			Duel.SetOperationInfo(0,CATEGORY_TODECK,rc,1,rc:GetControler(),rc:GetLocation())
		end
	else
		Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,0,0,rc:GetPreviousLocation())
	end
end
function s.distg_atk(e,tp,eg,ep,ev,re,r,rp,chk)
	local tg=e:GetLabelObject()
	if chk==0 then return tg and tg:IsAbleToDeck() end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,tg,1,tg:GetControler(),tg:GetLocation())
end
function s.disop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) and re:GetHandler():IsType(TYPE_MONSTER) and re:GetHandler():IsAbleToDeck() then
		Duel.SendtoDeck(eg,nil,SEQ_DECKBOTTOM,REASON_EFFECT)
	end
end
function s.disop_atk(e,tp,eg,ep,ev,re,r,rp)
	local tg=e:GetLabelObject()
	if Duel.NegateAttack() and tg and tg:IsRelateToBattle() and tg:IsType(TYPE_MONSTER) and tg:IsAbleToDeck() then
		Duel.SendtoDeck(tg,nil,SEQ_DECKBOTTOM,REASON_EFFECT)
	end
end

function s.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return e:GetHandler():GetFlagEffect(id)==0 and Duel.IsExistingMatchingCard(s.discfilter,tp,LOCATION_HAND,0,1,nil)
	end
	e:GetHandler():RegisterFlagEffect(id,RESET_CHAIN,0,1)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,s.discfilter,tp,LOCATION_HAND,0,1,1,nil)
	if #g>0 then
		Duel.SendtoGrave(g,REASON_COST)
	end
end
function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToDeck() end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,e:GetHandler(),1,0,0)
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsRelateToEffect(e) then
		Duel.SendtoDeck(e:GetHandler(),nil,SEQ_DECKBOTTOM,REASON_EFFECT)
	end
end