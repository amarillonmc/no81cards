--彩虹小队·狙击干员-灰烬
function c79029460.initial_effect(c)
	--SpecialSummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(79029460,0))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC_G)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c79029460.pendcon)
	e1:SetOperation(c79029460.pendop)
	e1:SetValue(SUMMON_TYPE_SPECIAL+1)
	c:RegisterEffect(e1)
	Duel.AddCustomActivityCounter(79029460,ACTIVITY_SPSUMMON,c79029460.counterfilter)
	--
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_TO_HAND)
	e2:SetCondition(c79029460.thscon)
	e2:SetOperation(c79029460.thsop)
	c:RegisterEffect(e2)
	--disable
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_DISABLE)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCountLimit(1,79029460)
	e3:SetTarget(c79029460.distg)
	e3:SetOperation(c79029460.disop)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EVENT_SUMMON_SUCCESS)
	c:RegisterEffect(e4)
end
function c79029460.counterfilter(c)
	return c:IsSetCard(0xa900)
end
function c79029460.spfil(c,e,tp)
	return c:IsSetCard(0x4904) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0
end
function c79029460.pendcon(e,c,og)
	if c==nil then return true end
	local tp=e:GetHandlerPlayer()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0,nil)+2<Duel.GetFieldGroupCount(tp,0,LOCATION_MZONE,nil) and Duel.IsExistingMatchingCard(c79029460.spfil,tp,LOCATION_EXTRA,0,1,nil,e,tp) and Duel.GetCustomActivityCount(79029460,tp,ACTIVITY_SPSUMMON)==0 and Duel.GetFlagEffect(tp,79029460)==0 
end
function c79029460.pendop(e,tp,eg,ep,ev,re,r,rp,c,sg,og)
	Debug.Message("专心执行我们的任务吧。")
	Duel.Hint(HINT_SOUND,0,aux.Stringid(79029460,2))
	Duel.RegisterFlagEffect(tp,79029460,RESET_PHASE+PHASE_END,0,1)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c79029460.splimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local ct=Duel.GetFieldGroupCount(tp,0,LOCATION_MZONE)-Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)
	local g=Duel.GetMatchingGroup(c79029460.spfil,tp,LOCATION_EXTRA,0,nil,e,tp)
	if ft<1 or ct<1 or g:GetCount()==0 then return end
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then ft=1 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g1=g:SelectSubGroup(tp,aux.dncheck,false,1,math.min(ft,ct)-1)
	sg:Merge(g1)
	sg:AddCard(e:GetHandler())
end
function c79029460.splimit(e,c,tp,sumtp,sumpos)
	return not c:IsSetCard(0xa900) and c:IsLocation(LOCATION_EXTRA)
end
function c79029460.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(aux.disfilter1,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
end
function c79029460.disop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(aux.disfilter1,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	if g:GetCount()<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local tc=g:Select(tp,1,1,nil):GetFirst()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) and not tc:IsDisabled() then
	Debug.Message("已发现目标！")
	Duel.Hint(HINT_SOUND,0,aux.Stringid(79029460,3))
		Duel.NegateRelatedChain(tc,RESET_TURN_SET)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e2:SetValue(RESET_TURN_SET)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e2)
		if tc:IsType(TYPE_TRAPMONSTER) then
			local e3=Effect.CreateEffect(c)
			e3:SetType(EFFECT_TYPE_SINGLE)
			e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e3:SetCode(EFFECT_DISABLE_TRAPMONSTER)
			e3:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e3)
		end
	if Duel.IsExistingMatchingCard(nil,tp,0,LOCATION_MZONE,1,nil) and c:IsOnField() and Duel.SelectYesNo(tp,aux.Stringid(79029460,1)) then 
	local bc=Duel.SelectMatchingCard(tp,nil,tp,0,LOCATION_MZONE,1,1,nil):GetFirst()
	Debug.Message("离远一点！")
	Duel.Hint(HINT_SOUND,0,aux.Stringid(79029460,4))
	Duel.CalculateDamage(c,bc)
	end
	end
end
function c79029460.thscon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetFlagEffect(79029469)~=0 and Duel.GetFlagEffect(tp,79029460)==0 
end
function c79029460.thsop(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():ResetFlagEffect(79029469)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0,nil)+2<Duel.GetFieldGroupCount(tp,0,LOCATION_MZONE,nil) and Duel.IsExistingMatchingCard(c79029460.spfil,tp,LOCATION_EXTRA,0,1,nil,e,tp) and Duel.GetCustomActivityCount(79029460,tp,ACTIVITY_SPSUMMON)==0 then 
	if Duel.SelectYesNo(tp,aux.Stringid(79029469,0)) then 
	local c=e:GetHandler()
	Duel.RegisterFlagEffect(tp,79029460,RESET_PHASE+PHASE_END,0,1)
	Debug.Message("专心执行我们的任务吧。")
	Duel.Hint(HINT_SOUND,0,aux.Stringid(79029460,2))
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c79029460.splimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local ct=Duel.GetFieldGroupCount(tp,0,LOCATION_MZONE)-Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)
	local g=Duel.GetMatchingGroup(c79029460.spfil,tp,LOCATION_EXTRA,0,nil,e,tp)
	if ft<1 or ct<1 or g:GetCount()==0 then return end
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then ft=1 end
	local sg=Group.CreateGroup()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g1=g:SelectSubGroup(tp,aux.dncheck,false,1,math.min(ft,ct)-1)
	sg:Merge(g1)
	sg:AddCard(e:GetHandler())
	Duel.SpecialSummon(sg,SUMMON_TYPE_SPECIAL+1,tp,tp,false,false,POS_FACEUP)
	end  
	end 
end









