--科技属 加速人马
function c50587164.initial_effect(c)
	--
	if c:GetOriginalCode()==50587164 then

	--link summon
	aux.AddLinkProcedure(c,nil,2,2,c50587164.lcheck)
	c:EnableReviveLimit()
	--adjust
	local e01=Effect.CreateEffect(c)
	e01:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e01:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e01:SetCode(EVENT_ADJUST)
	e01:SetRange(0xff)
	e01:SetOperation(c50587164.adjustop)
	c:RegisterEffect(e01)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(50587164,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,50587164)
	e1:SetCondition(c50587164.hspcon)
	e1:SetTarget(c50587164.hsptg)
	e1:SetOperation(c50587164.hspop)
	c:RegisterEffect(e1)
	--effect gain
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetRange(LOCATION_EXTRA)
	e2:SetCountLimit(1,50587165)
	e2:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e2:SetCondition(c50587164.effcon)
	e2:SetOperation(c50587164.effop)
	c:RegisterEffect(e2)

	end
end
function c50587164.lcheck(g,lc)
	return g:IsExists(Card.IsLinkSetCard,1,nil,0x27)
end
function c50587164.hspcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end
function c50587164.hspfilter(c,e,tp)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x27) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP)
end
function c50587164.hsptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c50587164.hspfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_DECK)
end
function c50587164.hspop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c50587164.hspfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,1,nil,e,tp)
	local tc=g:GetFirst()
	if tc then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c50587164.cfilter(c)
	return c:IsFacedown() or not c:IsSetCard(0x27)
end
function c50587164.effcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()~=tp and not Duel.IsExistingMatchingCard(c50587164.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c50587164.efcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()~=tp and (Duel.GetCurrentPhase()==PHASE_MAIN1 or  Duel.GetCurrentPhase()==PHASE_MAIN2)
end
function c50587164.eftg(e,c)
	return c:IsType(TYPE_EFFECT) and c:IsSetCard(0x27) and (c:IsFaceup() or not c:IsOnField())
end
function c50587164.effop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.ConfirmCards(1-tp,c)
	if not c50587164.globle_dialogue_check then
		c50587164.globle_dialogue_check=true
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(50587164,13))
		Duel.SelectOption(tp,aux.Stringid(50587164,9))
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(50587164,13))
		Duel.SelectOption(tp,aux.Stringid(50587164,10))
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(50587164,13))
		Duel.SelectOption(tp,aux.Stringid(50587164,11))
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(50587164,13))
		Duel.SelectOption(tp,aux.Stringid(50587164,12))
	end
	--Duel.Hint(HINT_MESSAGE,tp,aux.Stringid(50587164,9))
	Duel.Hint(HINT_CARD,0,50587164)
	--synchro effect
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(50587164,4))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)
	e2:SetRange(LOCATION_MZONE)
	e2:SetValue(50587164)
	e2:SetTarget(c50587164.sctarg)
	e2:SetOperation(c50587164.scop)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
	e3:SetTargetRange(0xff,0)
	e3:SetTarget(c50587164.eftg)
	e3:SetCondition(c50587164.efcon)
	e3:SetReset(RESET_PHASE+PHASE_END)
	e3:SetLabelObject(e2)
	Duel.RegisterEffect(e3,tp)
	--effect
	--change effect type
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(50587164,7))
	e4:SetProperty(EFFECT_FLAG_CLIENT_HINT)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(50587164)
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
	e5:SetTargetRange(LOCATION_HAND+LOCATION_MZONE+LOCATION_GRAVE+LOCATION_REMOVED,0)
	e5:SetTarget(c50587164.eftg)
	e5:SetCondition(c50587164.efcon)
	e5:SetReset(RESET_PHASE+PHASE_END)
	e5:SetLabelObject(e4)
	Duel.RegisterEffect(e5,tp)
end
function c50587164.sctarg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()

	if chk==0 and c:IsOriginalCodeRule(74627016) then return Duel.GetFlagEffect(tp,50587164)==0
		and (Duel.IsExistingMatchingCard(Card.IsSynchroSummonable,tp,LOCATION_EXTRA,0,1,nil,nil) or Duel.IsExistingMatchingCard(Card.IsLinkSummonable,tp,LOCATION_EXTRA,0,1,nil,nil,c)) end

	if chk==0 then return Duel.GetFlagEffect(tp,50587164)==0
		and (Duel.IsExistingMatchingCard(Card.IsSynchroSummonable,tp,LOCATION_EXTRA,0,1,nil,c) or Duel.IsExistingMatchingCard(Card.IsLinkSummonable,tp,LOCATION_EXTRA,0,1,nil,nil,c)) end

	Duel.RegisterFlagEffect(tp,50587164,RESET_CHAIN,0,1)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c50587164.scop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:GetControler()~=tp or not c:IsRelateToEffect(e) then return end
	local g=Duel.GetMatchingGroup(Card.IsSynchroSummonable,tp,LOCATION_EXTRA,0,nil,c)
	if c:IsOriginalCodeRule(74627016) then g=Duel.GetMatchingGroup(Card.IsSynchroSummonable,tp,LOCATION_EXTRA,0,nil,nil) end
	local g2=Duel.GetMatchingGroup(Card.IsLinkSummonable,tp,LOCATION_EXTRA,0,nil,nil,c)
	if g:GetCount()>0 and g2:GetCount()<=0 then 
		op=Duel.SelectOption(tp,aux.Stringid(50587164,5))+1
	elseif g2:GetCount()>0 and g:GetCount()<=0 then 
		op=Duel.SelectOption(tp,aux.Stringid(50587164,6))+2 
	elseif g:GetCount()>0 and g2:GetCount()>0 then 
		op=Duel.SelectOption(tp,aux.Stringid(50587164,5),aux.Stringid(50587164,6))+1
	end
	if op==1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=g:Select(tp,1,1,nil)
		Duel.SynchroSummon(tp,sg:GetFirst(),c)
	elseif op==2 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=g2:Select(tp,1,1,nil)
		Duel.LinkSummon(tp,sg:GetFirst(),nil,c)
	end
end

------------------Effect Change------------------

function c50587164.filter(c)
	return c:IsSetCard(0x27) and not c:IsCode(50587164) and c:IsType(TYPE_MONSTER)
end
function c50587164.actarget(e,te,tp)
	local tc=te:GetHandler()
	--prevent activating
	return (te:GetValue()==50587164 and not tc:IsHasEffect(50587164))  
	--prevent normal activating
	or (te:GetValue()==50587165 and tc:IsHasEffect(50587164))
end
function c50587164.adjustop(e,tp,eg,ep,ev,re,r,rp)
	--
	if not c50587164.globle_check then
		c50587164.globle_check=true
		local ge0=Effect.CreateEffect(e:GetHandler())
		ge0:SetType(EFFECT_TYPE_FIELD)
		ge0:SetCode(EFFECT_ACTIVATE_COST)
		ge0:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE)
		ge0:SetCost(aux.FALSE)
		ge0:SetTargetRange(1,1)
		ge0:SetTarget(c50587164.actarget)
		Duel.RegisterEffect(ge0,0)
		--Effect Gain
		local g=Duel.GetMatchingGroup(c50587164.filter,0,0xff,0xff,nil)
		cregister=Card.RegisterEffect
		esetcountLimit=Effect.SetCountLimit
		table_effect={}
		Card.RegisterEffect=function(card,effect,flag)
			if effect then
				local eff=effect:Clone()
				if effect:IsHasType(EFFECT_TYPE_IGNITION) then
					--effect edit
					eff:SetValue(50587165)
					local eff2=effect:Clone()
					--spell speed 2
					if eff2:IsHasType(EFFECT_TYPE_IGNITION) then
						eff2:SetType(EFFECT_TYPE_QUICK_O)
						eff2:SetCode(EVENT_FREE_CHAIN)
						eff2:SetHintTiming(0,TIMING_DRAW_PHASE+TIMING_MAIN_END+TIMINGS_CHECK_MONSTER)
					end
					eff2:SetValue(50587164)
					--spsummon in effect way
					table.insert(table_effect,eff2)
				end
				table.insert(table_effect,eff)
			end
			return 
		end
		for tc in aux.Next(g) do
			table_effect={}
			tc:ReplaceEffect(50587164,0)
			Duel.CreateToken(0,tc:GetOriginalCode())
			local sp_proc=nil
			for key,eff in ipairs(table_effect) do
				if eff:GetCode()==EFFECT_SPSUMMON_PROC and not tc:IsLocation(LOCATION_EXTRA) then
					sp_proc=eff
				end
				cregister(tc,eff)
			end
			--summon or spsummon
			local e2=Effect.CreateEffect(tc)
			e2:SetDescription(aux.Stringid(50587164,2))
			e2:SetCategory(CATEGORY_SUMMON)
			e2:SetType(EFFECT_TYPE_QUICK_O)
			e2:SetCode(EVENT_FREE_CHAIN)
			e2:SetHintTiming(0,TIMING_DRAW_PHASE+TIMING_MAIN_END+TIMINGS_CHECK_MONSTER)
			e2:SetRange(LOCATION_HAND)
			if sp_proc then
				e2:SetDescription(aux.Stringid(50587164,1))
				e2:SetCategory(CATEGORY_SUMMON+CATEGORY_SPECIAL_SUMMON)
				e2:SetLabelObject(sp_proc)
			end
			e2:SetTarget(c50587164.sum_sptg)
			e2:SetOperation(c50587164.sum_spop)
			e2:SetValue(50587164)
			cregister(tc,e2)
		end
		Card.RegisterEffect=cregister
		Effect.SetCountLimit=esetcountLimit
	end
	e:Reset()
end
function c50587164.sum_sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local sp_proc=e:GetLabelObject()
	if sp_proc then
		local con=sp_proc:GetCondition()
		if chk==0 then return Duel.GetFlagEffect(tp,50587164)==0 and (e:GetHandler():IsSummonable(false,nil) or (con(e,e:GetHandler()) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false))) end
		Duel.RegisterFlagEffect(tp,50587164,RESET_CHAIN,0,1)
		Duel.SetOperationInfo(0,CATEGORY_SUMMON,e:GetHandler(),1,0,0)
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
	else
		if chk==0 then return Duel.GetFlagEffect(tp,50587164)==0 and e:GetHandler():IsSummonable(false,nil) end
		Duel.RegisterFlagEffect(tp,50587164,RESET_CHAIN,0,1)
		Duel.SetOperationInfo(0,CATEGORY_SUMMON,e:GetHandler(),1,0,0)
	end
end
function c50587164.sum_spop(e,tp,eg,ep,ev,re,r,rp)
	local sp_proc=e:GetLabelObject()
	local c=e:GetHandler()
	if sp_proc then
		local con=sp_proc:GetCondition()
		local b1=e:GetHandler():IsSummonable(false,nil)
		local b2=con(e,e:GetHandler()) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false)
		if b1 and not b2 then 
			op=Duel.SelectOption(tp,aux.Stringid(50587164,2))+1
		elseif b2 and not b1 then 
			op=Duel.SelectOption(tp,aux.Stringid(50587164,3))+2 
		elseif b1 and b2 then 
			op=Duel.SelectOption(tp,aux.Stringid(50587164,2),aux.Stringid(50587164,3))+1
		end
		if op==1 then
			if c:IsRelateToEffect(e) then
				Duel.Summon(tp,c,false,nil)
			end
		elseif op==2 then
			if c:IsRelateToEffect(e) then
				Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
			end
		end
	else
		if c:IsRelateToEffect(e) and c:IsSummonable(false,nil) then
			Duel.Summon(tp,c,false,nil)
		end
	end
end
