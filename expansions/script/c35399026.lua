--离子炮龙-火型
function c35399026.initial_effect(c)
	--
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(35399026,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCountLimit(1,35399026)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c35399026.con1)
	e1:SetTarget(c35399026.tg1)
	e1:SetOperation(c35399026.op1)
	c:RegisterEffect(e1)	
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_HAND) 
	e2:SetCountLimit(1,15399026+EFFECT_COUNT_CODE_OATH)
	e2:SetCondition(c35399026.spcon)
	c:RegisterEffect(e2)
	--
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_BE_MATERIAL)
	e3:SetProperty(EFFECT_FLAG_EVENT_PLAYER)
	e3:SetCondition(c35399026.con3)
	e3:SetOperation(c35399026.op3)
	c:RegisterEffect(e3)
end
function c35399026.con1(e,tp,eg,ep,ev,re,r,rp)
	return rp~=tp and Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)<Duel.GetFieldGroupCount(tp,0,LOCATION_MZONE)
end 
function c35399026.spfil(c,e,tp) 
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and (c:IsLevelBelow(4) or c==e:GetHandler()) 
end 
function c35399026.gckfil(g,e,tp) 
	return g:IsContains(e:GetHandler()) and Duel.IsExistingMatchingCard(c35399026.espfil,tp,LOCATION_EXTRA,0,1,nil,e,tp,g) 
end 
function c35399026.espfil(c,e,tp,g) 
	return c:IsType(TYPE_SYNCHRO) and c:IsSynchroSummonable(nil,g)
end 
function c35399026.tg1(e,tp,eg,ep,ev,re,r,rp,chk)  
	local mg=Duel.GetMatchingGroup(c35399026.spfil,tp,LOCATION_HAND,0,nil,e,tp) 
	if chk==0 then return mg:CheckSubGroup(c35399026.gckfil,2,2,e,tp) and not Duel.IsPlayerAffectedByEffect(tp,59822133) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA) 
	Duel.SetOperationInfo(0,CATEGORY_DRAW,0,0,1-tp,1)
end
function c35399026.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end 
	local mg=Duel.GetMatchingGroup(c35399026.spfil,tp,LOCATION_HAND,0,nil,e,tp) 
	if not mg:CheckSubGroup(c35399026.gckfil,2,2,e,tp) then return end 
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then return end 
	Duel.Draw(1-tp,1,REASON_EFFECT)
	local sg=mg:SelectSubGroup(tp,c35399026.gckfil,false,2,2,e,tp) 
	Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)  
	Duel.BreakEffect()
	local cg=Duel.SelectMatchingCard(tp,c35399026.espfil,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,sg) 
	Duel.SynchroSummon(tp,cg:GetFirst(),nil,sg) 
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetTargetRange(1,0) 
	e1:SetLabelObject(cg:GetFirst())
	e1:SetTarget(c35399026.splimit) 
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end 
function c35399026.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return c:IsLocation(LOCATION_EXTRA) and e:GetLabelObject()~=c  
end
function c35399026.spcon(e,c)
	if c==nil then return true end
	return Duel.GetFieldGroupCount(c:GetControler(),LOCATION_MZONE,0)==0
		and Duel.GetFieldGroupCount(c:GetControler(),0,LOCATION_MZONE)>0
		and Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
end
function c35399026.con3(e,tp,eg,ep,ev,re,r,rp)
	return r==REASON_SYNCHRO 
end
function c35399026.op3(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler() 
	Duel.Hint(HINT_CARD,0,35399026)
	local rc=c:GetReasonCard() 
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(35399026,2))
	e1:SetCategory(CATEGORY_NEGATE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL+EFFECT_FLAG_CLIENT_HINT)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(c35399026.discon)
	e1:SetCost(c35399026.discost)
	e1:SetTarget(c35399026.distg)
	e1:SetOperation(c35399026.disop) 
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	rc:RegisterEffect(e1,true) 
end
function c35399026.efilter3_1(e,te)
	return te:IsActiveType(TYPE_MONSTER) and te:GetHandler():IsType(TYPE_XYZ+TYPE_LINK)
end
function c35399026.discon(e,tp,eg,ep,ev,re,r,rp)
	return rp==1-tp and not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) 
end
function c35399026.discost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsReleasable() end
	Duel.Release(e:GetHandler(),REASON_COST)
end
function c35399026.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(nil,tp,LOCATION_MZONE,LOCATION_MZONE,1,e:GetHandler()) end 
end
function c35399026.disop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler() 
	local g=Duel.GetMatchingGroup(nil,tp,LOCATION_MZONE,LOCATION_MZONE,e:GetHandler()) 
	if g:GetCount()>0 then 
	local tc=g:Select(tp,1,1,nil):GetFirst()  
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_IMMUNE_EFFECT)
	e2:SetValue(c35399026.efilter)
	e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
	e2:SetOwnerPlayer(tp)
	tc:RegisterEffect(e2) 
	end 
end
function c35399026.efilter(e,re)
	return e:GetHandler()~=re:GetOwner() and re~=e 
end






