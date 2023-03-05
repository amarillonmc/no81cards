--水精鳞-深渊特里同
local s,id,o=GetID()
function s.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsAttribute,ATTRIBUTE_WATER),4,2)
	c:EnableReviveLimit()
	--boost
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetHintTiming(0,TIMING_END_PHASE)
	e1:SetCountLimit(1,id)
	e1:SetCost(s.atkcost)
	e1:SetOperation(s.atkop)
	c:RegisterEffect(e1)
	--spsummon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,1))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetCountLimit(1,id+1)
	e3:SetCost(s.spcost)
	e3:SetTarget(s.sptg)
	e3:SetOperation(s.spop)
	c:RegisterEffect(e3)
end
function s.costfilter(c)
	return ((c:IsAttribute(ATTRIBUTE_WATER) and c:IsLocation(LOCATION_HAND)) or (c:IsSetCard(0x74) and c:IsLocation(LOCATION_DECK))) and c:IsType(TYPE_MONSTER) and c:IsAbleToGraveAsCost()
end
function s.atkcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.costfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local sg=Duel.SelectMatchingCard(tp,s.costfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,1,1,nil)
	Duel.SendtoGrave(sg,REASON_COST)
end
function s.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsFaceup() and c:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
		e1:SetValue(1000)
		c:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_UPDATE_DEFENSE)
		c:RegisterEffect(e2)
	end
end
function s.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function s.spfilter(c,e,tp)
	return c:IsAttribute(ATTRIBUTE_WATER) and c:IsLevel(4) and c:IsRace(RACE_FISH+RACE_SEASERPENT) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and s.spfilter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingTarget(s.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,s.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)>0 and tc:IsSetCard(0x74) then
		local Mermail_table_effect=s.Mermail_Geteffect(tc,e,tp,eg,ep,ev,re,r,rp)
		if #Mermail_table_effect>=1 then
			if #Mermail_table_effect==1 then
				local effect=table.unpack(Mermail_table_effect)
				local tg=effect:GetTarget()
				local op=effect:GetOperation()
				tc:RegisterEffect(effect)
				tc:CreateEffectRelation(effect)
				if not (not tg or tg(effect,tp,eg,ep,ev,re,r,rp,0)) then return end
				if not Duel.SelectYesNo(tp,aux.Stringid(id,3)) then return end
				Duel.Hint(HINT_CARD,0,tc:GetOriginalCode())
				if tg then tg(effect,tp,eg,ep,ev,re,r,rp,1) end
				local ttg=Group.CreateGroup()
				local ttg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
				if ttg then
					local ttg2=ttg:GetFirst()
					while ttg2 do
						ttg2:CreateEffectRelation(effect)
						ttg2=ttg:GetNext()
					end
				end
				if op then op(effect,tp,eg,ep,ev,re,r,rp,1) end
				tc:ReleaseEffectRelation(effect)
				if ttg then
					local ttg2=ttg:GetFirst()
					while ttg2 do
						ttg2:ReleaseEffectRelation(effect)
						ttg2=ttg:GetNext()
					end
				end
				effect:Reset()
			elseif #Mermail_table_effect==2 then
				Duel.ClearTargetCard()
				local effect1,effect2=table.unpack(Mermail_table_effect)
				local tg1=effect1:GetTarget()
				local tg2=effect2:GetTarget()
				local op=0
				tc:RegisterEffect(effect1)
				tc:CreateEffectRelation(effect1)
				tc:RegisterEffect(effect2)
				tc:CreateEffectRelation(effect2)
				if (not tg1 or tg1(effect1,tp,eg,ep,ev,re,r,rp,0)) and not (not tg2 or tg2(effect2,tp,eg,ep,ev,re,r,rp,0)) then
					if not Duel.SelectYesNo(tp,aux.Stringid(id,3)) then return end
					Duel.Hint(HINT_CARD,0,tc:GetOriginalCode())
					op=Duel.SelectOption(tp,effect1:GetDescription())+1
				elseif (not tg2 or tg2(effect2,tp,eg,ep,ev,re,r,rp,0)) and not (not tg1 or tg1(effect1,tp,eg,ep,ev,re,r,rp,0)) then
					if not Duel.SelectYesNo(tp,aux.Stringid(id,3)) then return end
					Duel.Hint(HINT_CARD,0,tc:GetOriginalCode())
					op=Duel.SelectOption(tp,effect2:GetDescription())+2 
				elseif (not tg1 or tg1(effect1,tp,eg,ep,ev,re,r,rp,0)) and (not tg2 or tg2(effect2,tp,eg,ep,ev,re,r,rp,0)) then
					if not Duel.SelectYesNo(tp,aux.Stringid(id,3)) then return end
					Duel.Hint(HINT_CARD,0,tc:GetOriginalCode())
					op=Duel.SelectOption(tp,effect1:GetDescription(),effect2:GetDescription())+1
				end
				if op==1 then
					local tg=effect1:GetTarget()
					local op=effect1:GetOperation()
					if not (not tg or tg(effect1,tp,eg,ep,ev,re,r,rp,0)) then return end
					if tg then tg(effect1,tp,eg,ep,ev,re,r,rp) end
					local ttg=Group.CreateGroup()
					local ttg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
					if ttg then
						local ttg2=ttg:GetFirst()
						while ttg2 do
							ttg2:CreateEffectRelation(effect1)
							ttg2=ttg:GetNext()
						end
					end
					if op then op(effect1,tp,eg,ep,ev,re,r,rp) end
					if ttg then
						local ttg2=ttg:GetFirst()
						while ttg2 do
							ttg2:ReleaseEffectRelation(effect1)
							ttg2=ttg:GetNext()
						end
					end
				elseif op==2 then
					local tg=effect2:GetTarget()
					local op=effect2:GetOperation()
					if not (not tg or tg(effect2,tp,eg,ep,ev,re,r,rp,0)) then return end
					if tg then tg(effect2,tp,eg,ep,ev,re,r,rp) end
					local ttg=Group.CreateGroup()
					local ttg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
					if ttg then
						local ttg2=ttg:GetFirst()
						while ttg2 do
							ttg2:CreateEffectRelation(effect2)
							ttg2=ttg:GetNext()
						end
					end
					if op then op(effect2,tp,eg,ep,ev,re,r,rp) end
					if ttg then
						local ttg2=ttg:GetFirst()
						while ttg2 do
							ttg2:ReleaseEffectRelation(effect2)
							ttg2=ttg:GetNext()
						end
					end
				end
				tc:ReleaseEffectRelation(effect1)
				effect1:Reset()
				tc:ReleaseEffectRelation(effect2)
				effect2:Reset()
			end
		end
	end
end
function s.Mermail_Geteffect(c,e,tp,eg,ep,ev,re,r,rp)
	cregister=Card.RegisterEffect
	cisAttribute=Card.IsAttribute
	cisDiscardable=Card.IsDiscardable
	cisAbleToGraveAsCost=Card.IsAbleToGraveAsCost
	disexistingiarget=Duel.IsExistingTarget
	disexistingmatchingcard=Duel.IsExistingMatchingCard
	local Mermail_effect=false
	Card.IsAttribute=function(card,att)
		return true
	end
	Card.IsDiscardable=function(card)
		Mermail_effect=true
		return true
	end
	Card.IsAbleToGraveAsCost=function(card)
		return true
	end
	Card.RegisterEffect=function(card,effect,flag)
		if effect and effect:GetType()~=EFFECT_TYPE_FIELD then
			Mermail_effect=false
			if Mermail_record and effect:GetCode()==EVENT_SPSUMMON_SUCCESS then Mermail_record=false return end
			local cost=effect:GetCost()
			if cost and cost(e,tp,eg,ep,ev,re,r,rp,0) then end
			if Mermail_effect then 
				local eff=effect:Clone()
				table.insert(table_effect,eff) 
			end
			if effect:GetCode()==EVENT_SUMMON_SUCCESS then Mermail_record=true end
		end
		return 
	end
	Duel.IsExistingMatchingCard=function(filter,player,s,o,count,c_g_n,...)
		if not Duel.GetFieldGroup(player,s,o) or #Duel.GetFieldGroup(player,s,o)<=0 then
			s=0xff
		end
		return disexistingmatchingcard(filter,player,s,o,count,c_g_n,...)
	end
	Duel.IsExistingTarget=function(filter,player,s,o,count,c_g_n,...)
		if not Duel.GetFieldGroup(player,s,o) or #Duel.GetFieldGroup(player,s,o)<=0 then
			s=0xff
		end
		return disexistingmatchingcard(filter,player,s,o,count,c_g_n,...)
	end
	Mermail_record=false
	table_effect={}
	Duel.CreateToken(0,c:GetOriginalCode())
	Card.RegisterEffect=cregister
	Card.IsAttribute=cisAttribute
	Card.IsDiscardable=cisDiscardable
	Card.IsAbleToGraveAsCost=cisAbleToGraveAsCost
	Duel.IsExistingTarget=disexistingiarget
	Duel.IsExistingMatchingCard=disexistingmatchingcard
	return table_effect
end
