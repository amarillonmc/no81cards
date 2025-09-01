local s,id,o=GetID()
function s.initial_effect(c)
	--①
	local e0=Effect.CreateEffect(c)
	e0:SetDescription(aux.Stringid(id,1))
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e0:SetCost(s.hhcost)
	c:RegisterEffect(e0)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_TOGRAVE+CATEGORY_SPECIAL_SUMMON+CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,id+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(s.e1tg)
	e1:SetOperation(s.e1op)
	c:RegisterEffect(e1)
	local e12=e1:Clone()
	e12:SetDescription(aux.Stringid(id,1))
	e12:SetRange(LOCATION_DECK)
	e12:SetCost(s.hhcost)
	c:RegisterEffect(e12)
	--②
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,2))
	e2:SetCategory(CATEGORY_REMOVE+CATEGORY_TODECK+CATEGORY_EQUIP+CATEGORY_SPECIAL_SUMMON)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCountLimit(1,id+10000)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(s.tg)
	e2:SetOperation(s.op)
	c:RegisterEffect(e2)
	
	local e4=Effect.CreateEffect(c)
    e4:SetType(EFFECT_TYPE_FIELD)
    e4:SetCode(EFFECT_ACTIVATE_COST)
    e4:SetRange(LOCATION_DECK)
    e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e4:SetTargetRange(1,0)
    e4:SetTarget(s.actarget)
    e4:SetOperation(s.costop)
    c:RegisterEffect(e4)
end
function s.e1fil(c,e,tp)
	local mg=Duel.GetMatchingGroup(s.e1filter,tp,LOCATION_DECK+LOCATION_ONFIELD+LOCATION_HAND,0,c)
	local ct=math.floor(c:GetLevel()/3)
	return c:IsSetCard(0x18d) and c:IsType(TYPE_MONSTER) and c:IsType(TYPE_RITUAL) and c:GetLevel()>2 and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,false,true) and #mg>0
		and mg:CheckSubGroup(s.check,ct,ct,tp,c)
end
function s.check(g,tp,fc)
	return Duel.GetLocationCountFromEx(tp,tp,g,fc)>0 and g:FilterCount(Card.IsAbleToGrave,nil)==g:GetCount()
end
function s.e1tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.e1fil,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function s.e1filter(c)
	return c:IsSetCard(0x18d) or c:IsType(TYPE_EQUIP)
end
function s.e1fil2(c)
	return c:IsSetCard(0x18d) and c:IsType(TYPE_MONSTER)
end
function s.e1op(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,s.e1fil,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	local tc=g:GetFirst()
	if tc then
		Duel.ConfirmCards(1-tp,tc)
		local ct=math.floor(tc:GetLevel()/3)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local mg=Duel.GetMatchingGroup(s.e1filter,tp,LOCATION_DECK+LOCATION_ONFIELD+LOCATION_HAND,0,e:GetHandler() and tc)
		if #mg>0 then
			local sg=mg:SelectSubGroup(tp,s.check,false,ct,ct,tp,tc)
			if #sg>0 then
				local cg=sg:Filter(Card.IsFacedown,nil)
				if #cg>0 then
					Duel.ConfirmCards(1-tp,cg)
				end
				if Duel.SendtoGrave(sg,REASON_EFFECT)~=0 and Duel.GetOperatedGroup():FilterCount(Card.IsLocation,nil,LOCATION_GRAVE)>0 and Duel.SpecialSummon(tc,SUMMON_TYPE_RITUAL,tp,tp,false,true,POS_FACEUP) then
					tc:CompleteProcedure()
					Duel.BreakEffect()
					if Duel.IsExistingMatchingCard(s.e1fil2,tp,LOCATION_MZONE,0,1,nil) then
						local lg=Duel.SelectMatchingCard(tp,s.e1fil2,tp,LOCATION_MZONE,0,1,1,nil)
						if #lg>0 then
							local tlg=lg:GetFirst()
							local c=e:GetHandler()
							Duel.Equip(tp,c,tlg)
							local e0=Effect.CreateEffect(c)
							e0:SetType(EFFECT_TYPE_SINGLE)
							e0:SetCode(EFFECT_EQUIP_LIMIT)
							e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
							e0:SetValue(s.eqlimit)
							e0:SetReset(RESET_EVENT+RESETS_STANDARD)
							c:RegisterEffect(e0)
							local e1=Effect.CreateEffect(c)
							e1:SetType(EFFECT_TYPE_EQUIP)
							e1:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
							e1:SetValue(1)
							c:RegisterEffect(e1)
							local e2=Effect.CreateEffect(c)
							e2:SetType(EFFECT_TYPE_FIELD)
							e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
							e2:SetRange(LOCATION_SZONE)
							e2:SetTargetRange(LOCATION_SZONE,0)
							e2:SetTarget(s.ditg)
							e2:SetValue(1)
							e2:SetReset(RESET_EVENT+RESETS_STANDARD)
							c:RegisterEffect(e2)
							c:CancelToGrave()
						end
					end	   
				end		   
			end   
		end
	end 
end
function s.eqlimit(e,c)
	return e:GetHandler():GetEquipTarget()==c or c:IsControler(e:GetHandlerPlayer()) and c:IsSetCard(0x18d)
end
function s.ditg(e,c)
	return c:IsFaceup()
end

function s.e1cofil(c,e,tp)
	return c:IsSetCard(0x18d) and c:IsType(TYPE_MONSTER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.hhcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(s.e1cofil,tp,LOCATION_HAND,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,s.e1cofil,tp,LOCATION_HAND,0,1,1,nil,e,tp)
	local tg=g:GetFirst()
	Duel.SpecialSummon(tg,0,tp,tp,false,false,POS_FACEUP)
end
function s.tdfilter(c)
	return (c:IsSetCard(0x18d) or c:IsType(TYPE_EQUIP)) and c:IsAbleToDeck()
end
function s.eqfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x18d)
end
function s.filter(c,tp)
	return c:IsFaceup() and c:IsAbleToChangeControler()
end
function s.e2fil4(c,e,tp)
	return c:IsSetCard(0x18d) and c:IsType(TYPE_XYZ) and c:IsCanBeSpecialSummoned(e,TYPE_SPSUMMON,tp,true,false)
end
function s.e2fil5(c)
	return c:IsType(TYPE_EQUIP)
end
function s.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE+LOCATION_REMOVED) and chkc:IsControler(tp) and s.tdfilter(chkc) end
	local t1=Duel.IsExistingTarget(s.tdfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,3,nil)
	if chk==0 then
		return t1
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,s.tdfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,3,3,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,g:GetCount(),0,0)
end
function s.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	if not tg or tg:FilterCount(Card.IsRelateToEffect,nil,e)~=3 then return end
	Duel.SendtoDeck(tg,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
	Duel.AdjustAll()
	local b1=Duel.IsExistingMatchingCard(s.eqfilter,tp,LOCATION_MZONE,0,1,nil) and Duel.IsExistingMatchingCard(s.filter,tp,0,LOCATION_MZONE,1,nil,tp) 
		and Duel.GetLocationCount(tp,LOCATION_SZONE)>0
	local b2=Duel.IsExistingMatchingCard(s.e2fil4,tp,LOCATION_EXTRA,0,1,nil,e,tp)
			and Duel.IsExistingMatchingCard(s.e2fil5,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,2,nil)
	local op=aux.SelectFromOptions(tp,
			{b1,aux.Stringid(id,4)},
			{b2,aux.Stringid(id,5)})
	if op==1 then
		Duel.BreakEffect()
		if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
		local g=Duel.SelectMatchingCard(tp,s.filter,tp,0,LOCATION_MZONE,1,1,nil,tp)
		local tc=g:GetFirst()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
		local g1=Duel.SelectMatchingCard(tp,s.eqfilter,tp,LOCATION_MZONE,0,1,1,nil)
		local tc1=g1:GetFirst()
		if tc and tc1 then
			if not Duel.Equip(tp,tc,tc1) then return end
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_EQUIP_LIMIT)
			e1:SetProperty(EFFECT_FLAG_OWNER_RELATE)
			e1:SetLabelObject(tc1)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			e1:SetValue(s.eqlimit2)
			tc:RegisterEffect(e1)
		end
	end
	if op==2 then
		Duel.BreakEffect()
		local g=Duel.SelectMatchingCard(tp,s.e2fil4,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
		if #g>0 and Duel.IsExistingMatchingCard(s.e2fil5,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,2,nil) then
			local tg=Duel.SelectMatchingCard(tp,s.e2fil5,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,2,2,nil)
			if #tg>0 and Duel.GetLocationCountFromEx(tp,tp,nil,g:GetFirst()) then
				Duel.Overlay(g:GetFirst(),tg)
				Duel.SpecialSummon(g:GetFirst(),0,tp,tp,true,false,POS_FACEUP)
			end
		end
	end
end
function s.eqlimit2(e,c)
	return c==e:GetLabelObject()
end
function s.actarget(e,te,tp)
    e:SetLabelObject(te)
    return te:GetHandler()==e:GetHandler()
end
function s.costop(e,tp,eg,ep,ev,re,r,rp)
    local te=e:GetLabelObject()
    local c=e:GetHandler()
    Duel.MoveToField(c,tp,tp,LOCATION_SZONE,POS_FACEUP,false)
    c:CreateEffectRelation(te)
    local ev0=Duel.GetCurrentChain()+1
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
    e1:SetCode(EVENT_CHAIN_SOLVED)
    e1:SetCountLimit(1)
    e1:SetCondition(function(e,tp,eg,ep,ev,re,r,rp) return ev==ev0 end)
    e1:SetOperation(s.rsop)
    e1:SetReset(RESET_CHAIN)
    Duel.RegisterEffect(e1,tp)
    local e2=e1:Clone()
    e2:SetCode(EVENT_CHAIN_NEGATED)
    Duel.RegisterEffect(e2,tp)
end
function s.rsop(e,tp,eg,ep,ev,re,r,rp)
    local rc=re:GetHandler()
    if e:GetCode()==EVENT_CHAIN_SOLVED and rc:IsRelateToEffect(re) then
        rc:SetStatus(STATUS_EFFECT_ENABLED,true)
    end
    if e:GetCode()==EVENT_CHAIN_NEGATED and rc:IsRelateToEffect(re) and not (rc:IsOnField() and rc:IsFacedown()) then
        rc:SetStatus(STATUS_ACTIVATE_DISABLED,true)
    end
end