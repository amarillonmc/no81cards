--场地
if not require and dofile then function require(str) return dofile(str..".lua") end end
if not pcall(function() require("expansions/script/c53702500") end) then require("script/c53702500") end
function c53771045.initial_effect(c)
	SNNM.Sarcoveil_Sort(c)
	--Activate
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e0:SetOperation(c53771045.acop)
	c:RegisterEffect(e0)
	--to grave
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOGRAVE+CATEGORY_DECKDES+CATEGORY_TOHAND+CATEGORY_GRAVE_ACTION)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(4179255)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetRange(LOCATION_FZONE)
	e1:SetCountLimit(1,53771045)
	e1:SetCondition(c53771045.tgcon)
	e1:SetTarget(c53771045.tgtg)
	e1:SetOperation(c53771045.tgop)
	c:RegisterEffect(e1)
	--activate cost
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_ACTIVATE_COST)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetRange(LOCATION_FZONE)
	e2:SetTargetRange(0,1)
	e2:SetCondition(c53771045.costcon)
	e2:SetTarget(c53771045.costtg)
	e2:SetCost(c53771045.costchk)
	e2:SetOperation(c53771045.costop)
	c:RegisterEffect(e2)
	--summon
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_SUMMON)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_FZONE)
	e3:SetCountLimit(1,53771045+1)
	e3:SetCost(c53771045.sumcost)
	e3:SetTarget(c53771045.sumtg)
	e3:SetOperation(c53771045.sumop)
	c:RegisterEffect(e3)
end
function c53771045.acop(e,tp,eg,ep,ev,re,r,rp)
	Duel.RaiseEvent(e:GetHandler(),4179255,e,0,tp,tp,Duel.GetCurrentChain())
end
function c53771045.tgcon(e,tp,eg,ep,ev,re,r,rp)
	return re and re:GetHandler()==e:GetHandler()
end
function c53771045.tgfilter(c)
	return c:IsSetCard(0xa53b) and c:IsAbleToGrave()
end
function c53771045.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c53771045.tgfilter,tp,LOCATION_DECK,0,2,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,2,tp,LOCATION_DECK)
end
function c53771045.tgop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c53771045.tgfilter,tp,LOCATION_DECK,0,2,2,nil)
	if #g==2 and Duel.SendtoGrave(g,REASON_EFFECT)~=0 and g:FilterCount(Card.IsLocation,nil,0x10)~=0 then
		Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_ATOHAND)
		local tg=g:FilterSelect(1-tp,Card.IsAbleToHand,1,1,nil)
		if #tg~=0 then
			Duel.SendtoHand(tg,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,tg)
		end
	end
end
function c53771045.chkfilter(c)
	local et={Duel.IsPlayerAffectedByEffect(c:GetControler(),EFFECT_CANNOT_FLIP_SUMMON)}
	for _,v in pairs(et) do
		local tg=v:GetTarget() or aux.TRUE 
		if tg(v,c) then return false end
	end
	local le={c:IsHasEffect(EFFECT_FLIPSUMMON_COST)}
	for _,v in pairs(le) do
		local tg=v:GetTarget() or aux.TRUE
		local cost=v:GetCost() or aux.TRUE
		if tg(v,c) and not cost(v,c,c:GetControler()) then return false end
	end
	return not c:IsStatus(STATUS_CANNOT_CHANGE_FORM) and not c:IsHasEffect(EFFECT_CANNOT_FLIP_SUMMON) and c:IsFacedown()
end
function c53771045.costcon(e)
	return Duel.IsExistingMatchingCard(c53771045.chkfilter,Duel.GetTurnPlayer(),LOCATION_MZONE,0,1,nil)
end
function c53771045.costtg(e,te,tp)
	e:SetLabelObject(te)
	return true
end
function c53771045.costchk(e,te,tp)
	return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,te:GetHandler())
end
function c53771045.costop(e,tp,eg,ep,ev,re,r,rp)
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD,e:GetLabelObject():GetHandler())
end
function c53771045.sumcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,1000) end
	Duel.PayLPCost(tp,1000)
end
function c53771045.sumfilter(c)
	return c:IsSetCard(0xa53b) and (c:IsSummonable(true,nil) or c:IsMSetable(true,nil))
end
function c53771045.sumtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c53771045.sumfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_SUMMON,nil,1,0,0)
end
function c53771045.sumop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SUMMON)
	local tc=Duel.SelectMatchingCard(tp,c53771045.sumfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,1,nil):GetFirst()
	if not tc then return end
	local s1=tc:IsSummonable(true,nil)
	local s2=tc:IsMSetable(true,nil)
	if (s1 and s2 and Duel.SelectPosition(tp,tc,POS_FACEUP_ATTACK+POS_FACEDOWN_DEFENSE)==POS_FACEUP_ATTACK) or not s2 then
		Duel.Summon(tp,tc,true,nil)
	else
		tc:RegisterFlagEffect(53771045,RESET_EVENT+0xfe0000+RESET_PHASE+PHASE_END,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(53771045,4))
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_MSET)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_SET_AVAILABLE)
		e1:SetLabelObject(tc)
		e1:SetOperation(c53771045.fsop)
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)
		Duel.MSet(tp,tc,true,nil)
	end
end
function c53771045.fsop(e,tp,eg,ep,ev,re,r,rp)
	if not eg:GetFirst()==e:GetLabelObject() or e:GetLabelObject():GetFlagEffect(53771045)==0 then return end
	e:GetLabelObject():SetStatus(STATUS_CANNOT_CHANGE_FORM,false)
end
