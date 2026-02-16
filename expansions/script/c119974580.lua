--禁征龙-缄龙
local s,id,o=GetID()
function s.initial_effect(c)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e4:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e4:SetCode(EVENT_ADJUST)
	e4:SetRange(0xff)
	e4:SetOperation(s.adjustop)
	c:RegisterEffect(e4)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND+LOCATION_MZONE)
	e1:SetTarget(s.copytg)
	e1:SetOperation(s.copyop)
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
	e0:SetRange(LOCATION_DECK)
	e0:SetTargetRange(LOCATION_HAND+LOCATION_MZONE,0)
	e0:SetTarget(s.eftg)
	e0:SetLabelObject(e1)
	c:RegisterEffect(e0)
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND|CATEGORY_SEARCH|CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetCountLimit(1,id)
	e2:SetTarget(s.thtg)
	e2:SetOperation(s.thop)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCountLimit(1,id+o)
	e3:SetCost(aux.bfgcost)
	e3:SetTarget(s.sptg)
	e3:SetOperation(s.spop)
	c:RegisterEffect(e3)
end
function s.drdiseff(c,e,tp,eg,ep,ev,re,r,rp)
	if c.Dragon_Ruler_handes_effect then return c.Dragon_Ruler_handes_effect end
	return s[c:GetOriginalCodeRule()]
end
function s.efffilter(c,e,tp,eg,ep,ev,re,r,rp)
	if not (c:IsSetCard(0x1c4) and c:IsAbleToGraveAsCost()) then return false end
	local te=s.drdiseff(c,e,tp,eg,ep,ev,re,r,rp)
	if not te then return false end
	local tg=te:GetTarget()
	return not tg or tg(e,tp,eg,ep,ev,re,r,rp,0,nil,c)
end
function s.costfilter(c)
	return c:IsCode(id) and c:IsAbleToGraveAsCost()
end
function s.copytg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return e:IsCostChecked() and s.efffilter(c,e,tp,eg,ep,ev,re,r,rp) and Duel.IsExistingMatchingCard(s.costfilter,tp,LOCATION_DECK,0,1,nil) end
	local tc=Duel.GetFirstMatchingCard(s.costfilter,tp,LOCATION_DECK,0,1,nil)
	Duel.SendtoGrave(Group.FromCards(c,tc),REASON_COST)
	local te=s.drdiseff(c,e,tp,eg,ep,ev,re,r,rp)
	e:SetProperty(te:GetProperty())
	Duel.ClearTargetCard()
	e:SetLabelObject(te)
	local tg=te:GetTarget()
	if tg then tg(e,tp,eg,ep,ev,re,r,rp,1) end
	Duel.ClearOperationInfo(0)
end
function s.copyop(e,tp,eg,ep,ev,re,r,rp)
	local te=e:GetLabelObject()
	local op=te:GetOperation()
	if op then op(e,tp,eg,ep,ev,re,r,rp) end
end
function s.eftg(e,c)
	return c:IsSetCard(0x1c4) and c:IsType(TYPE_MONSTER)
end
function s.thfilter(c,e,tp)
	if not (c:IsSetCard(0x1c4) and c:IsType(TYPE_MONSTER)) then return false end
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	return c:IsAbleToHand() or ft>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
	local g=Duel.SelectMatchingCard(tp,s.thfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	local tc=g:GetFirst()
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if tc:IsAbleToHand() or ft>0 and tc:IsCanBeSpecialSummoned(e,0,tp,false,false) then
		if Duel.SelectOption(tp,1190,1152)==0 then
			Duel.SendtoHand(tc,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,tc)
		elseif Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP) then
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_CANNOT_ATTACK)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			tc:RegisterEffect(e1)
			Duel.SpecialSummonComplete()
		end
	end
end
function s.spfilter(c,e,tp)
	return c:IsSetCard(0x1c4) and not c:IsCode(id) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_DEFENSE)
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and s.spfilter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingTarget(s.spfilter,tp,LOCATION_GRAVE,0,1,e:GetHandler(),e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,s.spfilter,tp,LOCATION_GRAVE,0,1,1,e:GetHandler(),e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and aux.NecroValleyFilter()(tc) and Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP_DEFENSE) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetValue(RESET_TURN_SET)
		tc:RegisterEffect(e2)
		Duel.SpecialSummonComplete()
		local op=aux.SelectFromOptions(tp,{Duel.IsExistingMatchingCard(Card.IsSynchroSummonable,tp,LOCATION_EXTRA,0,1,nil,nil),1164},{Duel.IsExistingMatchingCard(Card.IsXyzSummonable,tp,LOCATION_EXTRA,0,1,nil,nil),1165},{true,1212})
		if op==1 then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local sg=Duel.SelectMatchingCard(tp,Card.IsSynchroSummonable,tp,LOCATION_EXTRA,0,1,1,nil,nil)
			Duel.SynchroSummon(tp,sg:GetFirst(),nil)
		elseif op==2 then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local sg=Duel.SelectMatchingCard(tp,Card.IsXyzSummonable,tp,LOCATION_EXTRA,0,1,1,nil,nil)
			Duel.XyzSummon(tp,sg:GetFirst(),nil)
		end
	end
end

function s.filter(c)
	return c:IsSetCard(0x1c4) and c:IsType(TYPE_MONSTER) and not c:IsCode(id)
end
function s.adjustop(e,tp,eg,ep,ev,re,r,rp)
	if not s.globle_check then
		s.globle_check=true
		local g=Duel.GetMatchingGroup(s.filter,0,0xff,0xff,nil)
		cregister=Card.RegisterEffect
		cisDiscardable=Card.IsDiscardable
		local marked=false
		Card.IsDiscardable=function(card)
			marked=true
			return true
		end
		Card.RegisterEffect=function(card,effect,flag)
			if effect and effect:GetType()~=EFFECT_TYPE_FIELD then
				marked=false
				local cost=effect:GetCost()
				if cost and cost(e,tp,eg,ep,ev,re,r,rp,0) then end
				if marked then 
					local eff=effect:Clone()
					table.insert(table_effect,eff) 
				end
			end
			return 
		end
		for tc in aux.Next(g) do
			marked=false
			table_effect={}
			Duel.CreateToken(0,tc:GetOriginalCode())
			for key,eff in ipairs(table_effect) do
				s[tc:GetOriginalCode()]=eff
			end
		end
		Card.RegisterEffect=cregister
		Card.IsDiscardable=cisDiscardable
	end
	e:Reset()
end
