--玉莲帮
local s,id,o=GetID()
function s.initial_effect(c)
	c:EnableReviveLimit()
	--initial
	local e01=Effect.CreateEffect(c)
	e01:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e01:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e01:SetCode(EVENT_ADJUST)
	e01:SetRange(0xff)
	e01:SetOperation(s.initial)
	c:RegisterEffect(e01)
	--move to field
	if Duel.DisableActionCheck then
		--gain tp
		local ct=Duel.GetFieldGroupCount(0,0,LOCATION_DECK)
		local tp=0
		if ct>0 then tp=1 end
		--
		if s[tp] and s[tp]==1 then return end
		s[tp]=1
		--confirm
		Duel.DisableActionCheck(true)
		pcall(Duel.ConfirmCards,0,c)
		pcall(Duel.Hint,HINT_CARD,0,id)
		Duel.DisableActionCheck(false)
		--to grave
		s[100]=0
		Duel.DisableActionCheck(true)
		pcall(s.tograve,c,tp)
		Duel.DisableActionCheck(false)
		-->1
		if s[100]>=1 then
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_FIELD)
			e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
			e1:SetCode(EFFECT_CANNOT_SUMMON)
			e1:SetTargetRange(1,0)
			e1:SetTarget(s.splimit)
			Duel.RegisterEffect(e1,tp)
			local e2=e1:Clone()
			e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
			Duel.RegisterEffect(e2,tp)
		end
		-->5
		if s[100]>=5 then
			--adjust
			local e3=Effect.CreateEffect(c)
			e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			e3:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
			e3:SetCode(EVENT_ADJUST)
			e3:SetOperation(s.adjustop)
			Duel.RegisterEffect(e3,tp)
		end
		-->10
		if s[100]>=10 then
			--grave activate
			local e4=Effect.CreateEffect(c)
			e4:SetType(EFFECT_TYPE_FIELD)
			e4:SetCode(id)
			e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
			e4:SetTargetRange(1,0)
			Duel.RegisterEffect(e4,tp)
		end
		-->15
		if s[100]>=15 then
			--return replace
			local e5=Effect.CreateEffect(c)
			e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			e5:SetCode(EFFECT_SEND_REPLACE)
			e5:SetTarget(s.reptg2)
			e5:SetOperation(s.repop2)
			e5:SetValue(s.repval2)
			Duel.RegisterEffect(e5,tp)
		end
	end
end
function s.tgfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x88) and c:IsAbleToGrave() and c:IsRace(RACE_BEAST+RACE_WINDBEAST)
end
function s.tograve(c,tp)
	--
	local g=Duel.GetMatchingGroup(s.tgfilter,tp,LOCATION_DECK,0,nil)
	local fg=Group.CreateGroup()
	for tc in aux.Next(g) do
		if fg:FilterCount(Card.IsCode,nil,tc:GetCode())==0 then
			fg:AddCard(tc)
		end
	end
	s[100]=#fg
	Duel.SendtoGrave(fg,REASON_EFFECT)
end
function s.splimit(e,c)
	return not c:IsSetCard(0x88)
end
function s.spcfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x88) and c:IsRace(RACE_BEASTWARRIOR)
end
function s.setfilter(c)
	return c:IsSetCard(0x88) and c:IsRace(RACE_BEASTWARRIOR) and not c:IsForbidden()
end
function s.adjustop(e,tp,eg,ep,ev,re,r,rp)
	local phase=Duel.GetCurrentPhase()
	if (phase==PHASE_DAMAGE and not Duel.IsDamageCalculated()) or phase==PHASE_DAMAGE_CAL then return end
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(aux.NecroValleyFilter(s.setfilter),tp,LOCATION_HAND+LOCATION_GRAVE+LOCATION_REMOVED,0,nil)
	if not Duel.IsExistingMatchingCard(s.spcfilter,tp,LOCATION_MZONE,0,1,nil) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and g:GetCount()>0
	then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
		Duel.Hint(HINT_CARD,1-tp,id)
		local sg=g:Select(tp,1,1,nil)
		Duel.MoveToField(sg:GetFirst(),tp,tp,LOCATION_MZONE,POS_FACEUP,true)
		Duel.Readjust()
	end
end
function s.repfilter2(c,tp,re,rp)
	return c:IsLocation(LOCATION_GRAVE) and c:IsSetCard(0x88)
		and c:GetDestination()~=LOCATION_GRAVE and c:IsRace(RACE_BEAST+RACE_WINDBEAST) and 
		((c:GetReasonCard() and c:GetReasonCard()==c) or 
		(re and re:GetOwner()==c) or
		rp~=tp)
		--and re:GetOwner()==c
end
function s.reptg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return eg:IsExists(s.repfilter2,1,nil,tp,re,rp) and Duel.IsExistingMatchingCard(aux.TRUE,tp,0,LOCATION_DECK+LOCATION_ONFIELD+LOCATION_GRAVE+LOCATION_REMOVED,1,nil) end
	return true
	--[[if Duel.SelectYesNo(tp,aux.Stringid(id,4)) then
		return true
	else return false end]]
end
function s.repop2(e,tp,eg,ep,ev,re,r,rp)
	--Duel.SendtoGrave(e:GetHandler(),REASON_EFFECT)
	local g=Duel.GetFieldGroup(tp,0,LOCATION_GRAVE+LOCATION_ONFIELD+LOCATION_REMOVED)
	local tg=Duel.GetDecktopGroup(1-tp,1)
	if #tg>0 then g:Merge(tg) end
	if #g>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPPO)
		local exg=g:Select(tp,1,1,nil):GetFirst()
		for i=1,99 do
			local te,tgp=Duel.GetChainInfo(i,CHAININFO_TRIGGERING_EFFECT,CHAININFO_TRIGGERING_PLAYER)
			if not te then break end
			--if exg:IsRelateToEffect(te) then Debug.Message("0") end
			exg:ReleaseEffectRelation(te)
			if te:GetHandler() then exg:ReleaseRelation(te:GetHandler()) end
			--if exg:IsRelateToEffect(te) then Debug.Message("1") end
		end
		local og=exg:GetOverlayGroup()
		if og:GetCount()>0 then
			Duel.SendtoGrave(og,REASON_RULE)
		end
		Duel.Exile(exg,REASON_EFFECT)
	end
end
function s.repval2(e,c)
	return c:IsControler(e:GetHandlerPlayer()) and c:IsLocation(LOCATION_GRAVE) and c:IsSetCard(0x88) and c:IsRace(RACE_BEAST+RACE_WINDBEAST) 
end
function s.filter(c)
	return c:IsOriginalSetCard(0x88) and c:IsType(TYPE_MONSTER) and c:IsRace(RACE_BEAST+RACE_WINDBEAST) 
end
function s.quick_filter(e,tc,tp,eg,ep,ev,re,r,rp)
	local sendtograve_boolean=false
	local cisabletograveascost=Card.IsAbleToGraveAsCost
	local dGetCustomActivityCount=Duel.GetCustomActivityCount
	Duel.GetCustomActivityCount=function()
		return 0
	end
	local tc=e:GetHandler()
	Card.IsAbleToGraveAsCost=function(card)
		if card==tc then 
			sendtograve_boolean=true
			--Debug.Message("01")
		end
		return cisabletograveascost(card)
	end
	local cost=e:GetCost()
	if cost then cost(e,tp,eg,ep,ev,re,r,rp,0) end
	Card.IsAbleToGraveAsCost=cisabletograveascost
	Duel.GetCustomActivityCount=dGetCustomActivityCount
	if e:IsHasRange(LOCATION_HAND) and sendtograve_boolean and not s.in_array(e,Blacklotus_Bujin_Effect) then
		Blacklotus_Bujin_Effect[#Blacklotus_Bujin_Effect+1]=e
	end
	return false
end
function s.in_array(b,list)
  if not list then
	return false 
  end 
  if list then
	for _,ct in pairs(list) do
	  if ct==b then return true end
	end
  end
  return false
end 
function s.initial(e,tp,eg,ep,ev,re,r,rp)
	--
	if not s.globle_check_initial then
		s.globle_check_initial=true
		local c=e:GetHandler()
		--
		local g=Duel.GetMatchingGroup(s.filter,0,0xff,0xff,nil)
		for tc in aux.Next(g) do
			Blacklotus_Bujin_Effect={}
			local boolean=tc:IsOriginalEffectProperty(s.quick_filter,tc,tp,eg,ep,ev,re,r,rp)
			--Debug.Message("0")
			if #Blacklotus_Bujin_Effect>0 then
				--Debug.Message("1")
				for _,effect in pairs(Blacklotus_Bujin_Effect) do
					local c_effect=effect:Clone()
					local cost=effect:GetCost()
					c_effect:SetDescription(aux.Stringid(id,3))
					c_effect:SetRange(LOCATION_GRAVE)
					c_effect:SetCost(function(e,tp,eg,ep,ev,re,r,rp,chk)
						local c=e:GetHandler()
						if chk==0 then return Duel.IsPlayerAffectedByEffect(tp,id)~=nil and Duel.GetFlagEffect(tp,id+c:GetOriginalCode())==0 and c:IsAbleToRemoveAsCost() end
						Duel.Remove(c,POS_FACEUP,REASON_COST)
						Duel.RegisterFlagEffect(tp,id+c:GetOriginalCode(),RESET_PHASE+PHASE_END,0,1)
					end)
					tc:RegisterEffect(c_effect)
				end
			end
		end
	end
	e:Reset()
end
