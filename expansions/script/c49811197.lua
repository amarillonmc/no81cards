--A・ジェネクス・バーサタイル
local s,id,o=GetID()
function s.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(nil),1)
	c:EnableReviveLimit()
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,id)
	e1:SetCondition(s.spcon)
	e1:SetTarget(s.sptg)
	e1:SetOperation(s.spop)
	c:RegisterEffect(e1)
	--copy effect
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,id+1)
	e2:SetCost(s.copycost)
	e2:SetOperation(s.copyop)
	c:RegisterEffect(e2)
	
end
function s.spcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_SYNCHRO)
end
function s.spfilter(c,e,tp)
	return c:IsCode(68505803) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
end
function s.lvfilter(c)
	return c:IsLevelBelow(6) and c:IsFaceup()
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,s.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	if Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)>0 then
		local sg=Duel.GetMatchingGroup(s.lvfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
		if sg:GetCount()>0 and e:GetHandler():IsFaceup() and Duel.SelectYesNo(tp,aux.Stringid(id,3)) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
			local tg=sg:Select(tp,1,1,nil)
			Duel.HintSelection(tg)
			local lv=tg:GetFirst():GetLevel()
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_UPDATE_LEVEL)
			e1:SetValue(-lv)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
			e:GetHandler():RegisterEffect(e1)
		end
	end
end
function s.copyfilter(c)
	return c:IsSetCard(0x2) and c:IsType(TYPE_SYNCHRO) and c:IsAbleToRemoveAsCost()
end
function s.copycost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(s.copyfilter,tp,LOCATION_EXTRA,0,1,nil) and c:GetFlagEffect(id)==0 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,s.copyfilter,tp,LOCATION_EXTRA,0,1,1,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
	e:SetLabelObject(g:GetFirst())
	e:SetLabel(g:GetFirst():GetOriginalCode())
	c:RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
end
function s.copyop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=e:GetLabelObject()
	local code=e:GetLabel()
	if c:IsRelateToEffect(e) and c:IsFaceup() then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		e1:SetCode(EFFECT_CHANGE_CODE)
		e1:SetValue(code)
		c:RegisterEffect(e1)
		local e0=e1:Clone()
		e0:SetCode(EFFECT_CHANGE_ATTRIBUTE)
		e0:SetValue(tc:GetAttribute())
		c:RegisterEffect(e0)
		--s.on(e,tp,eg,ep,ev,re,r,rp)
		local cid=c:CopyEffect(code,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,1)
		--s.off(e,tp,eg,ep,ev,re,r,rp)
		local e2=Effect.CreateEffect(c)
		e2:SetDescription(aux.Stringid(id,2))
		e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e2:SetCode(EVENT_PHASE+PHASE_END)
		e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
		e2:SetCountLimit(1)
		e2:SetRange(LOCATION_MZONE)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		e2:SetLabelObject(e1)
		e2:SetLabel(cid)
		e2:SetOperation(s.rstop)
		c:RegisterEffect(e2)
	end
end
function s.rstop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local cid=e:GetLabel()
	c:ResetEffect(cid,RESET_COPY)
	c:ResetEffect(RESET_DISABLE,RESET_EVENT)
	local e1=e:GetLabelObject()
	e1:Reset()
	Duel.HintSelection(Group.FromCards(c))
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end

----------------cost change---------------

function s.on(e,tp,eg,ep,ev,re,r,rp)
		--get discard effect
		cregister=Card.RegisterEffect
		cisdiscardable=Card.IsDiscardable
		cisabletograveascost=Card.IsAbleToGraveAsCost
		disexitingmatchingcard=Duel.IsExistingMatchingCard
		Card.IsDiscardable=function(card,reason)
			Genex_discard_effect_check=true
			return true
		end
		Card.IsAbleToGraveAsCost=function(card)
			Genex_discard_effect_check=true
			return true
		end
		Duel.IsExistingMatchingCard=function(filter,player,s,o,ct,int,...)
			if s&LOCATION_HAND==LOCATION_HAND then
				Genex_discard_effect_location_check=true
			end
			return disexitingmatchingcard(filter,player,s,o,ct,int,...)
		end
		Card.RegisterEffect=function(card,effect,flag)
			if effect then
				if effect:GetCost() then
					local cost=effect:GetCost()
					Genex_discard_effect_check=false
					Genex_discard_effect_location_check=false

					local r=cost(e,tp,eg,ep,ev,re,r,rp,0)
					if Genex_discard_effect_check and Genex_discard_effect_location_check then
						effect:SetCost(function(e,tp,eg,ep,ev,re,r,rp,chk)
							if chk==0 then
								if Duel.GetFlagEffect(tp,49811193)~=0 then
									Genex_cost_check=true
									local Genex_boolean=cost(e,tp,eg,ep,ev,re,r,rp,0)
									Genex_cost_check=false
									return Genex_boolean and e:GetHandler():GetFlagEffect(49811193)==0
								end
								return cost(e,tp,eg,ep,ev,re,r,rp,0)
							end
							if Duel.GetFlagEffect(tp,49811193)~=0 then
								--Genex_cost_check=true
								--cost(e,tp,eg,ep,ev,re,r,rp,chk)
								--Genex_cost_check=false
								Duel.Hint(HINT_CARD,0,49811193)
								e:GetHandler():RegisterFlagEffect(e:GetHandler(),49811193,RESET_CHAIN,0,1)
								return 
							end
							cost(e,tp,eg,ep,ev,re,r,rp,chk)
						end)
					end
				end
			end
			return cregister(card,effect,flag)
		end
end

function s.off(e,tp,eg,ep,ev,re,r,rp)
		--reset
		Card.RegisterEffect=cregister
		Duel.IsExistingMatchingCard=disexitingmatchingcard
		Effect.SetRange=esetrange

		Card.IsDiscardable=cisdiscardable
		Card.IsAbleToGraveAsCost=cisabletograveascost
end
