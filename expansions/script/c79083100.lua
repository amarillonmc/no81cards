--圣赐乐土 菲亚梅塔
function c79083100.initial_effect(c)
	c:EnableReviveLimit()
	--ritual summon
	local e1=aux.AddRitualProcGreater2(c,c79083100.filter,LOCATION_HAND+LOCATION_GRAVE,nil,c79083100.matfilter)
	e1:SetDescription(aux.Stringid(79083100,0))
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetRange(LOCATION_HAND)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END+TIMING_END_PHASE)
	e1:SetCountLimit(1,79083100)
	e1:SetCondition(c79083100.rscon)
	e1:SetCost(c79083100.rscost)
	--destroy
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(79083100,0))
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e2:SetCountLimit(1,19083100)
	e2:SetTarget(c79083100.seqtg)
	e2:SetOperation(c79083100.seqop)
	c:RegisterEffect(e2)	
	--attribute
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetCode(EFFECT_ADD_RACE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetValue(RACE_FAIRY)
	c:RegisterEffect(e3)
end
c79083100.named_with_Laterano=true 
function c79083100.filter(c,e,tp,chk)
	return c.named_with_Laterano and (not chk or c~=e:GetHandler())
end
function c79083100.matfilter(c,e,tp,chk)
	return not chk or c~=e:GetHandler()
end
function c79083100.rscon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2
end
function c79083100.rscost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsDiscardable() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST+REASON_DISCARD)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(c79083100.splimit) 
	e1:SetLabelObject(e)
	e1:SetReset(RESET_CHAIN)
	e:GetHandler():RegisterEffect(e1)
end
function c79083100.splimit(e,se,sp,st)
	return se~=e:GetLabelObject() 
end
function c79083100.desfilter(c)
	return not c:IsLocation(LOCATION_SZONE) or c:GetSequence()<5
end
function c79083100.seqfilter(c,seq)
	local loc=LOCATION_MZONE
	if seq>8 then
		loc=LOCATION_SZONE
		seq=seq-8
	end
	if seq>=5 and seq<=7 then return false end
	local cseq=c:GetSequence()
	local cloc=c:GetLocation()
	if cloc==LOCATION_SZONE and cseq>=5 then return false end
	if cloc==LOCATION_MZONE and cseq>=5 and loc==LOCATION_MZONE
		and (seq==1 and cseq==5 or seq==3 and cseq==6) then return true end
	return cseq==seq or cloc==loc and math.abs(cseq-seq)==1
end
function c79083100.seqtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(c79083100.desfilter,tp,0,LOCATION_ONFIELD,1,nil) end
	local filter=0
	for i=0,16 do
		if not Duel.IsExistingMatchingCard(c79083100.seqfilter,tp,0,LOCATION_ONFIELD,1,nil,i) then
			filter=filter|1<<(i+16)
		end
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local flag=Duel.SelectField(tp,1,0,LOCATION_ONFIELD,filter)
	local seq=math.log(flag>>16,2)
	e:SetLabel(seq,flag)
	local g=Duel.GetMatchingGroup(c79083100.seqfilter,tp,0,LOCATION_ONFIELD,nil,seq)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c79083100.seqop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local seq,flag=e:GetLabel()
	local ct=Duel.GetMatchingGroupCount(c79083100.seqfilter,tp,0,LOCATION_ONFIELD,nil,seq)
	if ct<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.GetMatchingGroup(c79083100.seqfilter,tp,0,LOCATION_ONFIELD,nil,seq)
	Duel.HintSelection(g)
	local x=Duel.Destroy(g,REASON_EFFECT)
	if flag==nil then return end 
	if (flag==1 and Duel.IsPlayerAffectedByEffect(tp,79083110)) 
	or (flag==2 and Duel.IsPlayerAffectedByEffect(tp,79083210)) 
	or (flag==4 and Duel.IsPlayerAffectedByEffect(tp,79083310))  
	or (flag==8 and Duel.IsPlayerAffectedByEffect(tp,79083410))   
	or (flag==16 and Duel.IsPlayerAffectedByEffect(tp,79083510)) 
	or (flag==256 and Duel.IsPlayerAffectedByEffect(tp,79083610))
	or (flag==512 and Duel.IsPlayerAffectedByEffect(tp,79083710))
	or (flag==1024 and Duel.IsPlayerAffectedByEffect(tp,79083810))
	or (flag==2048 and Duel.IsPlayerAffectedByEffect(tp,79083910))
	or (flag==4096 and Duel.IsPlayerAffectedByEffect(tp,79083010))
	or (flag==65536*1 and Duel.IsPlayerAffectedByEffect(1-tp,79083110)) 
	or (flag==65536*2 and Duel.IsPlayerAffectedByEffect(1-tp,79083210)) 
	or (flag==65536*4 and Duel.IsPlayerAffectedByEffect(1-tp,79083310))  
	or (flag==65536*8 and Duel.IsPlayerAffectedByEffect(1-tp,79083410))   
	or (flag==65536*16 and Duel.IsPlayerAffectedByEffect(1-tp,79083510)) 
	or (flag==65536*256 and Duel.IsPlayerAffectedByEffect(1-tp,79083610))
	or (flag==65536*512 and Duel.IsPlayerAffectedByEffect(1-tp,79083710))
	or (flag==65536*1024 and Duel.IsPlayerAffectedByEffect(1-tp,79083810))
	or (flag==65536*2048 and Duel.IsPlayerAffectedByEffect(1-tp,79083910))
	or (flag==65536*4096 and Duel.IsPlayerAffectedByEffect(1-tp,79083010))  then 
	Duel.Hint(HINT_CARD,0,79083100) 
	Duel.Hint(HINT_SOUND,0,aux.Stringid(79083100,1)) 
	Duel.Hint(24,0,aux.Stringid(79083100,2))
	Duel.Damage(1-tp,x*1000,REASON_EFFECT)
	end
end


