--B.O.W.猎杀者
Duel.LoadScript("c16199990.lua")
local m,cm=rk.set(16130006,"BOW")
function cm.initial_effect(c)
	--leave field SpecialSummon
	local e0=Effect.CreateEffect(c)
	e0:SetDescription(aux.Stringid(m,4))
	e0:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e0:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e0:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e0:SetCode(EVENT_LEAVE_FIELD)
	e0:SetCondition(cm.spcon1)
	e0:SetTarget(cm.sptg1)
	e0:SetOperation(cm.spop1)
	c:RegisterEffect(e0) 
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e1:SetCountLimit(1,m)
	e1:SetCondition(cm.spcon)
	e1:SetOperation(cm.spop)
	c:RegisterEffect(e1)  
	--Equip
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,1))
	e2:SetCategory(CATEGORY_EQUIP+CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetCountLimit(1)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTarget(cm.eqtg)
	e2:SetOperation(cm.eqop)
	c:RegisterEffect(e2)  
end
function cm.spcon1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousLocation(LOCATION_ONFIELD) and not c:IsLocation(LOCATION_DECK)
end
function cm.sptg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,tp,0)
end
function cm.spop1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
		if Duel.SpecialSummonStep(c,0,tp,tp,false,false,POS_FACEUP) then
			local e0=Effect.CreateEffect(c)
			e0:SetType(EFFECT_TYPE_SINGLE)
			e0:SetCode(EFFECT_UPDATE_ATTACK)
			e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e0:SetValue(1000)
			e0:SetReset(RESET_EVENT+RESETS_STANDARD)
			c:RegisterEffect(e0)
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_DISABLE)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			c:RegisterEffect(e1)
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_DISABLE_EFFECT)
			e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e2:SetReset(RESET_EVENT+RESETS_STANDARD)
			c:RegisterEffect(e2)
			local e3=Effect.CreateEffect(c)
			e3:SetType(EFFECT_TYPE_SINGLE)
			e3:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
			e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e3:SetReset(RESET_EVENT+RESETS_REDIRECT)
			e3:SetValue(LOCATION_DECKBOT)
			c:RegisterEffect(e3)
		end
		Duel.SpecialSummonComplete()
	end   
end
function cm.spcost(c)  
	return c:IsAbleToRemoveAsCost() and c:IsRace(RACE_ZOMBIE)
end
function cm.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local g=Duel.GetMatchingGroup(cm.spcost,c:GetControler(),LOCATION_GRAVE,0,e:GetHandler())
	return g:GetCount()>0 and ft>0
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=Duel.GetMatchingGroup(cm.spcost,c:GetControler(),LOCATION_GRAVE,0,e:GetHandler())
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	aux.GCheckAdditional=aux.dncheck
	local rg=g:SelectSubGroup(tp,aux.mzctcheck,false,1,1,tp)
	aux.GCheckAdditional=nil
	Duel.Remove(rg,POS_FACEUP,REASON_COST)
	local e1_1=Effect.CreateEffect(e:GetHandler())
	e1_1:SetType(EFFECT_TYPE_SINGLE)
	e1_1:SetCode(EFFECT_CANNOT_TRIGGER)
	e1_1:SetReset(RESET_EVENT+0x1fe0000)
	rg:GetFirst():RegisterEffect(e1_1,true)
end
function cm.thfilter(c,e,tp)
	return c:IsAbleToHand() and not c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsRace(RACE_ZOMBIE)
end
function cm.eqtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.thfilter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,0,tp,LOCATION_DECK)
end
function cm.eqfilter(c,flag,tp)
	if not (Duel.GetLocationCount(tp,LOCATION_SZONE)>0) or c:IsForbidden() then return false end
	if flag==1 then 
		return c:IsType(TYPE_MONSTER) and c:IsRace(RACE_ZOMBIE)
	elseif flag==2 then
		return true
	end
end
function cm.eqop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(cm.thfilter,tp,LOCATION_DECK,0,nil,e,tp)
	local dcount=Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)
	local seq=-1
	local tc=g:GetFirst()
	local spcard=nil
	while tc do
		if tc:GetSequence()>seq then
			seq=tc:GetSequence()
			spcard=tc
		end
		tc=g:GetNext()
	end
	if seq==-1 then
		Duel.ConfirmDecktop(tp,dcount)
		Duel.ShuffleDeck(tp)
		return
	end
	Duel.ConfirmDecktop(tp,dcount-seq)
	if spcard:IsAbleToHand() then
		Duel.DisableShuffleCheck()
		if dcount-seq==1 then Duel.SendtoHand(spcard,tp,REASON_EFFECT)
		else
			Duel.SendtoHand(spcard,tp,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,spcard)
			local g=Duel.GetDecktopGroup(tp,dcount-seq-1)
			local num=g:FilterCount(Card.IsRace,nil,RACE_ZOMBIE)
			if num>14 then
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
				local eqg1=g:FilterSelect(tp,cm.eqfilter,1,1,nil,1,tp)
				if eqg1:GetCount()>0 then
					local eqc1=eqg1:GetFirst()
					if not Duel.Equip(tp,eqc1,c,true) then return end
					g:RemoveCard(eqc1)
					if eqc1:GetOriginalType()~=TYPE_SPELL+TYPE_EQUIP then
						local e1=Effect.CreateEffect(c)
						e1:SetType(EFFECT_TYPE_SINGLE)
						e1:SetCode(EFFECT_EQUIP_LIMIT)
						e1:SetReset(RESET_EVENT+RESETS_STANDARD)
						e1:SetValue(cm.eqlimit)
						e1:SetLabelObject(c)
						eqc1:RegisterEffect(e1)
					end
			   end
			end
			if num>24 then
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
				local eqg2=g:FilterSelect(tp,cm.eqfilter,1,2,nil,2,tp)
				if eqg2:GetCount()>0 then
					for eqc2 in aux.Next(eqg2) do
						if not Duel.Equip(tp,eqc2,c,true) then return end
							local e1=Effect.CreateEffect(c)
							e1:SetType(EFFECT_TYPE_SINGLE)
							e1:SetCode(EFFECT_EQUIP_LIMIT)
							e1:SetReset(RESET_EVENT+RESETS_STANDARD)
							e1:SetValue(cm.eqlimit)
							e1:SetLabelObject(c)
							eqc2:RegisterEffect(e1)
					end
			   end
			end
		end
	end
end
function cm.eqlimit(e,c)
	return c==e:GetLabelObject()
end