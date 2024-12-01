--支配恶魔
local s,id,o=GetID()
function s.initial_effect(c)
	c:EnableReviveLimit()
	--add code
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_ADD_CODE)
	e1:SetValue(12847313)
	c:RegisterEffect(e1)
	c:EnableReviveLimit()
	--cannot special summon
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetCode(EFFECT_SPSUMMON_CONDITION)
	c:RegisterEffect(e2)
	--to grave&special summon
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOGRAVE)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_CHAINING)
	e3:SetRange(LOCATION_HAND+LOCATION_MZONE)
	e3:SetCondition(s.tgcon)
	e3:SetTarget(s.tgtg)
	e3:SetOperation(s.tgop)
	c:RegisterEffect(e3)
	--special summon
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetCode(EVENT_DESTROYED)
	e4:SetCountLimit(1,id)
	e4:SetCondition(s.spcon)
	e4:SetTarget(s.sptg)
	e4:SetOperation(s.spop)
	c:RegisterEffect(e4)
	local e5=e4:Clone()
	e5:SetCode(EVENT_REMOVE)
	c:RegisterEffect(e5)
end
function s.tgcon(e,tp,eg,ep,ev,re,r,rp)
	local race=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_RACE)
	return not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) and rp==tp and re:IsActiveType(TYPE_MONSTER) and race&RACE_FIEND>0 and not re:GetHandler():IsSummonableCard() 
	and ((re:GetHandler():IsAttribute(ATTRIBUTE_DARK) and Duel.GetFlagEffect(tp,id)==0)
		or (re:GetHandler():IsAttribute(ATTRIBUTE_EARTH) and Duel.GetFlagEffect(tp,id+o)==0)
		or (re:GetHandler():IsAttribute(ATTRIBUTE_WATER) and Duel.GetFlagEffect(tp,id+o*2)==0) 
		or (re:GetHandler():IsAttribute(ATTRIBUTE_FIRE) and Duel.GetFlagEffect(tp,id+o*3)==0) 
		or (re:GetHandler():IsAttribute(ATTRIBUTE_WIND) and Duel.GetFlagEffect(tp,id+o*4)==0))
end
function s.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local rc=re:GetHandler()
	if not rc:IsRelateToEffect(re) then return end
	local proc=rc:IsCode(12866705) and c:IsCode(12866600)
	local b1=rc:IsAbleToGrave() and not rc:IsLocation(LOCATION_GRAVE+LOCATION_REMOVED)
	local b2=(Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and (rc:IsCanBeSpecialSummoned(e,0,tp,false,false)) or rc:IsCanBeSpecialSummoned(e,0,tp,proc,proc))
	if chk==0 then return b1 or b2 end
	if re:GetHandler():IsAttribute(ATTRIBUTE_DARK) then
		Duel.RegisterFlagEffect(tp,id,RESET_PHASE+PHASE_END,EFFECT_FLAG_OATH,1)
	elseif re:GetHandler():IsAttribute(ATTRIBUTE_EARTH) then
		Duel.RegisterFlagEffect(tp,id+o,RESET_PHASE+PHASE_END,EFFECT_FLAG_OATH,1)
	elseif re:GetHandler():IsAttribute(ATTRIBUTE_WATER) then
		Duel.RegisterFlagEffect(tp,id+o*2,RESET_PHASE+PHASE_END,EFFECT_FLAG_OATH,1)
	elseif re:GetHandler():IsAttribute(ATTRIBUTE_FIRE) then
		Duel.RegisterFlagEffect(tp,id+o*3,RESET_PHASE+PHASE_END,EFFECT_FLAG_OATH,1)
	elseif re:GetHandler():IsAttribute(ATTRIBUTE_WIND) then
		Duel.RegisterFlagEffect(tp,id+o*4,RESET_PHASE+PHASE_END,EFFECT_FLAG_OATH,1)
	end
	Duel.SetTargetCard(rc)
end
function s.tgop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
	local rc=re:GetHandler()
	if rc:IsRelateToEffect(re) then
		local tc=Duel.GetFirstTarget()
		local proc=rc:IsCode(12866705) and c:IsCode(12866600)
		local b1=tc:IsAbleToGrave() and not tc:IsLocation(LOCATION_GRAVE+LOCATION_REMOVED)
		local b2=Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and (tc:IsCanBeSpecialSummoned(e,0,tp,false,false) or tc:IsCanBeSpecialSummoned(e,0,tp,proc,proc))
		local off=1
		local ops={}
		local opval={}
		if b1 then
			ops[off]=1191
			opval[off]=0
			off=off+1
		end
		if b2 then
			ops[off]=1152
			opval[off]=1
			off=off+1
		end
		local op=Duel.SelectOption(tp,table.unpack(ops))+1
		local sel=opval[op]
		if sel==0 then
			Duel.SendtoGrave(tc,REASON_EFFECT)
		elseif sel==1 then
			Duel.SpecialSummon(tc,0,tp,tp,proc,proc,POS_FACEUP)
			if proc then tc:CompleteProcedure() end
		end
	end
end
function s.spcon(e,tp,eg,ep,ev,re,r,rp)
	local tp=e:GetHandlerPlayer()
	return  e:GetHandler():IsPreviousControler(tp) and rp~=tp
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.GetFieldGroupCount(tp,0,LOCATION_MZONE)>0 and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,true,true) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsRelateToEffect(e) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
		if Duel.SpecialSummon(e:GetHandler(),0,tp,tp,true,true,POS_FACEUP)>0 then
		local g=Duel.SelectMatchingCard(tp,aux.TRUE,tp,0,LOCATION_MZONE,1,6,nil)
		local tc=g:GetFirst()
		local sg=Group.CreateGroup()
			if #g>0 then
			Duel.HintSelection(g)
				while tc do 
				Duel.GetControl(tc,tp)
				if tc:IsControler(1-tp) then sg:AddCard(tc) end
				tc=g:GetNext()
				end	   
			Duel.SendtoGrave(sg,REASON_EFFECT) 
			end
		end
	end	
end