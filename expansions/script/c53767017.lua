if not require and dofile then function require(str) return dofile(str..".lua") end end
if not pcall(function() require("expansions/script/c53702500") end) then require("script/c53702500") end
local s,id,o=GetID()
function s.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddFusionProcFunRep2(c,aux.FilterBoolFunction(Card.IsRace,RACE_INSECT),4,114,true)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_TOGRAVE+CATEGORY_TOHAND+CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(2)
	e1:SetTarget(s.rttg)
	e1:SetOperation(s.rtop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SPECIAL_SUMMON+CATEGORY_DECKDES)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetRange(LOCATION_MZONE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCode(EVENT_PHASE+PHASE_END)
	e2:SetTarget(s.sptg)
	e2:SetOperation(s.spop)
	c:RegisterEffect(e2)
end
function s.rttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(nil,tp,LOCATION_REMOVED,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_REMOVED)
end
function s.fselect(g)
	if #g==1 then return true end
	local loc1,loc2=g:GetFirst():GetLocation()|0xc,g:GetNext():GetLocation()|0xc
	return loc1~=loc2
end
function s.rtop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
	local tc=Duel.SelectMatchingCard(tp,nil,tp,LOCATION_REMOVED,0,1,1,nil):GetFirst()
	if not tc then return end
	local ct,res=0,false
	if tc:IsAbleToDeck() and Duel.SelectYesNo(tp,aux.Stringid(id,2)) then
		ct=Duel.SendtoDeck(tc,nil,2,REASON_EFFECT)
		res=ct>0 and tc:IsLocation(LOCATION_DECK+LOCATION_EXTRA)
	else
		ct=Duel.SendtoGrave(tc,REASON_EFFECT+REASON_RETURN)
		res=ct>0 and tc:IsLocation(LOCATION_GRAVE)
	end
	local g1=Duel.GetMatchingGroup(Card.IsAbleToGrave,0,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	local g2=Duel.GetMatchingGroup(function(c)return c:GetType()&0x20002==0x20002 and c:IsAbleToGrave()end,tp,LOCATION_DECK,0,nil)
	g1:Merge(g2)
	if res and #g1>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local sg1=g1:SelectSubGroup(tp,s.fselect,false,1,2)
		local og=SNNM.WhitkinsToGrave(sg1,REASON_EFFECT):Filter(Card.IsLocation,nil,LOCATION_GRAVE)
		local oc=og:Filter(Card.IsPreviousLocation,nil,LOCATION_DECK):GetFirst()
		if oc and oc:GetType()&0x20002==0x20002 then
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_ADD_TYPE)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetValue(TYPE_TRAP)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			oc:RegisterEffect(e1,true)
			oc:RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(id,3))
			local rt={e1}
			local cp={}
			local f=Card.RegisterEffect
			Card.RegisterEffect=function(tc,te,bool)
				if te:GetType()==0x4a and (not te:GetRange() or te:GetRange()&LOCATION_GRAVE~=0) then table.insert(cp,te) end
				return f(tc,te,bool)
			end
			Duel.CreateToken(tp,oc:GetOriginalCode())
			Card.RegisterEffect=f
			for _,v in pairs(cp) do
				local e2=v:Clone()
				e2:SetType(EFFECT_TYPE_QUICK_O)
				e2:SetCode(EVENT_FREE_CHAIN)
				e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
				e2:SetReset(RESET_EVENT+RESETS_STANDARD)
				oc:RegisterEffect(e2,true)
				table.insert(rt,e2)
			end
			local e4=Effect.CreateEffect(e:GetHandler())
			e4:SetType(EFFECT_TYPE_FIELD)
			e4:SetCode(EFFECT_CANNOT_ACTIVATE)
			e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE)
			e4:SetRange(LOCATION_GRAVE)
			e4:SetTargetRange(1,1)
			e4:SetValue(function(e,re,tp)
				return re:GetHandler()==e:GetHandler() and re:GetType()==0x4a
			end)
			e4:SetReset(RESET_EVENT+RESETS_STANDARD)
			oc:RegisterEffect(e4,true)
			table.insert(rt,e4)
			local e3=Effect.CreateEffect(e:GetHandler())
			e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			e3:SetCode(EVENT_CHAINING)
			e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e3:SetRange(LOCATION_GRAVE)
			e3:SetCondition(function(e,tp,eg,ep,ev,re,r,rp)
				return re:GetHandler()==e:GetHandler()
			end)
			e3:SetOperation(function(e,tp,eg,ep,ev,re,r,rp)
				for _,v in pairs(rt) do v:Reset() end
				oc:ResetFlagEffect(id)
				e:Reset()
			end)
			e3:SetReset(RESET_EVENT+RESETS_STANDARD)
			oc:RegisterEffect(e3,true)
		end
		local g3=Duel.GetMatchingGroup(aux.NecroValleyFilter(Card.IsAbleToRemove),0,LOCATION_GRAVE,LOCATION_GRAVE,nil)
		if #og~=0 and #g3>0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
			local sg2=g3:SelectSubGroup(tp,function(g)return g:GetClassCount(Card.GetControler)==#g end,false,1,2)
			Duel.Remove(sg2,POS_FACEUP,REASON_EFFECT)
		end
	end
end
function s.thfilter(c)
	return c:GetType()&0x20002==0x20002 and c:IsAbleToHand()
end
function s.spfilter(c,e,tp)
	return c:IsRace(RACE_INSECT) and c:IsAttribute(ATTRIBUTE_WIND) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and s.thfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(s.thfilter,tp,LOCATION_GRAVE,0,1,nil) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_GRAVE+LOCATION_DECK,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,s.thfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.SendtoHand(tc,nil,REASON_EFFECT)>0 and tc:IsLocation(LOCATION_HAND) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(s.spfilter),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,e,tp)
		if #g>0 then
			Duel.BreakEffect()
			Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end
