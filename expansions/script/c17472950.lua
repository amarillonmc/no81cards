--域控·吟风
function c17472950.initial_effect(c)  
	c:EnableReviveLimit()
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	c:RegisterEffect(e1)
	--special summon rule
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_EXTRA)
	e2:SetCondition(c17472950.sprcon)
	e2:SetTarget(c17472950.sprtg)
	e2:SetOperation(c17472950.sprop)
	c:RegisterEffect(e2)
	--ind
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e1:SetValue(function(e,c)
	return not c:IsType(TYPE_SYNCHRO) end)
	c:RegisterEffect(e1)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_IMMUNE_EFFECT) 
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(function(e,te)
	return te:IsActiveType(TYPE_MONSTER) and not te:GetOwner():IsType(TYPE_SYNCHRO) end)
	c:RegisterEffect(e1) 
	--xx
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SUMMON_SUCCESS) 
	e2:SetProperty(EFFECT_FLAG_DELAY) 
	e2:SetRange(LOCATION_MZONE)   
	e2:SetCondition(c17472950.xxcon)
	e2:SetTarget(c17472950.xxtg) 
	e2:SetOperation(c17472950.xxop)
	c:RegisterEffect(e2)
	local e3=e2:Clone() 
	e3:SetCode(EVENT_SPSUMMON_SUCCESS) 
	c:RegisterEffect(e3) 
	local e4=e2:Clone() 
	e4:SetCode(EVENT_MSET) 
	c:RegisterEffect(e4) 
end 
function c17472950.tgrfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_SYNCHRO) and c:IsLevelAbove(1) and c:IsAbleToGraveAsCost()
end
function c17472950.mnfilter(c,g)
	return g:IsExists(c17472950.mnfilter2,1,c,c)
end
function c17472950.mnfilter2(c,mc)
	return c:GetLevel()-mc:GetLevel()==1 and c:GetOriginalRace()==mc:GetOriginalRace() and c:GetOriginalAttribute()==mc:GetOriginalAttribute()
end
function c17472950.fselect(g,tp,sc)
	return g:GetCount()==2
		and g:IsExists(Card.IsType,1,nil,TYPE_TUNER) and g:IsExists(aux.NOT(Card.IsType),1,nil,TYPE_TUNER)
		and g:IsExists(c17472950.mnfilter,1,nil,g)
		and Duel.GetLocationCountFromEx(tp,tp,g,sc)>0
end
function c17472950.sprcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local g=Duel.GetMatchingGroup(c17472950.tgrfilter,tp,LOCATION_MZONE,0,nil)
	return g:CheckSubGroup(c17472950.fselect,2,2,tp,c)
end
function c17472950.sprtg(e,tp,eg,ep,ev,re,r,rp,chk,c)
	local g=Duel.GetMatchingGroup(c17472950.tgrfilter,tp,LOCATION_MZONE,0,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local sg=g:SelectSubGroup(tp,c17472950.fselect,true,2,2,tp,c)
	if sg then
		sg:KeepAlive()
		e:SetLabelObject(sg)
		return true
	else return false end
end
function c17472950.sprop(e,tp,eg,ep,ev,re,r,rp,c)
	local tg=e:GetLabelObject()
	Duel.SendtoGrave(tg,REASON_SPSUMMON)
	tg:DeleteGroup()
end
function c17472950.xxcon(e,tp,eg,ep,ev,re,r,rp) 
	return eg:IsExists(Card.IsSummonPlayer,1,nil,1-tp)  
end 
function c17472950.xxtg(e,tp,eg,ep,ev,re,r,rp,chk) 
	local g=Duel.GetFieldGroup(tp,0,LOCATION_EXTRA)
	if chk==0 then return g:GetCount()>0 end 
end 
function c17472950.xxop(e,tp,eg,ep,ev,re,r,rp)   
	local c=e:GetHandler()  
	local g=Duel.GetFieldGroup(tp,0,LOCATION_EXTRA)
	if g:GetCount()>0 then 
		local tc=g:RandomSelect(tp,1):GetFirst() 
		Duel.ConfirmCards(tp,tc) 
		if tc:IsType(TYPE_SYNCHRO) then 
			 local g=Duel.GetFieldGroup(tp,0,LOCATION_EXTRA)
			 local b1=Duel.GetFlagEffect(tp,17472950)==0 and tc:IsAbleToRemove()
			 local b2=Duel.GetFlagEffect(tp,27472950)==0 and tc:IsCanBeSpecialSummoned(e,SUMMON_TYPE_SYNCHRO,tp,false,false)
			 local xtable={} 
			 table.insert(xtable,aux.Stringid(17472950,1)) 
			 if b1 then table.insert(xtable,aux.Stringid(17472950,2)) end 
			 if b2 then table.insert(xtable,aux.Stringid(17472950,3)) end 
			 local op=Duel.SelectOption(tp,table.unpack(xtable))+1 
			 if xtable[op]==aux.Stringid(17472950,2) then 
				 Duel.RegisterFlagEffect(tp,17472950,RESET_PHASE+PHASE_END,0,1) 
				 Duel.Remove(tc,POS_FACEDOWN,REASON_EFFECT+REASON_TEMPORARY) 
				 tc:RegisterFlagEffect(17472950,RESET_EVENT+RESETS_STANDARD,0,1) 
				 local e1=Effect.CreateEffect(e:GetHandler())
				 e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
				 e1:SetCode(EVENT_PHASE+PHASE_END)
				 e1:SetReset(RESET_PHASE+PHASE_END)
				 e1:SetLabelObject(tc)
				 e1:SetCountLimit(1)
				 e1:SetOperation(function(e,tp,eg,ep,ev,re,r,rp)
				 local tc=e:GetLabelObject()
				 if tc:GetFlagEffect(17472950)==0 then return end
				 Duel.Hint(HINT_CARD,0,17472950)
				 Duel.SendtoDeck(tc,nil,SEQ_DECKTOP,REASON_EFFECT) end)
				 Duel.RegisterEffect(e1,tp)
			 end 
			 if xtable[op]==aux.Stringid(17472950,3) then 
				 Duel.RegisterFlagEffect(tp,27472950,RESET_PHASE+PHASE_END,0,1)
				 Duel.SpecialSummon(tc,SUMMON_TYPE_SYNCHRO,tp,tp,false,false,POS_FACEUP) 
				 tc:CompleteProcedure()
			 end 
		else 
			if c:IsRelateToEffect(e) then 
				local e1=Effect.CreateEffect(c) 
				e1:SetType(EFFECT_TYPE_SINGLE) 
				e1:SetCode(EFFECT_UPDATE_ATTACK) 
				e1:SetRange(LOCATION_MZONE) 
				e1:SetValue(800) 
				e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END) 
				c:RegisterEffect(e1) 
				local e1=Effect.CreateEffect(c) 
				e1:SetType(EFFECT_TYPE_SINGLE) 
				e1:SetCode(EFFECT_UPDATE_DEFENSE) 
				e1:SetRange(LOCATION_MZONE) 
				e1:SetValue(800) 
				e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END) 
				c:RegisterEffect(e1) 
			end 
		end 
		Duel.ShuffleExtra(1-tp)
	end 
end 

