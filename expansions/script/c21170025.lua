--天启录的灭世者
function c21170025.initial_effect(c)
	c:EnableReviveLimit()
	local e0=Effect.CreateEffect(c)
	e0:SetDescription(1164)
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetCode(EFFECT_SPSUMMON_PROC)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetRange(LOCATION_EXTRA)
	e0:SetCondition(c21170025.syncon())
	e0:SetTarget(c21170025.syntg())
	e0:SetOperation(Auxiliary.SynOperation(nil,nil,nil,nil))
	e0:SetValue(SUMMON_TYPE_SYNCHRO)
	c:RegisterEffect(e0)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(21170025,0))
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_ATKCHANGE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,21170025)
	e1:SetCondition(c21170025.con)
	e1:SetTarget(c21170025.tg)
	e1:SetOperation(c21170025.op)
	c:RegisterEffect(e1)	
end
function c21170025.syn(c,syncard)
	return c:IsLocation(LOCATION_HAND) and c:IsPublic() and c:IsSetCard(0x6917) and c:GetOriginalType()==TYPE_SPELL
end
function c21170025.syn2(c)
	return c:IsRace(RACE_FIEND)
end
function c21170025.GetSynMaterials(tp,syncard)
	local mg=Duel.GetSynchroMaterial(tp):Filter(Auxiliary.SynMaterialFilter,nil,syncard):Filter(Card.IsRace,nil,RACE_FIEND)
	if mg:IsExists(Card.GetHandSynchro,1,nil) then
		local mg2=Duel.GetMatchingGroup(Card.IsCanBeSynchroMaterial,tp,LOCATION_HAND,0,nil,syncard)
		if mg2:GetCount()>0 then mg:Merge(mg2) end
	end
	local mg3=Duel.GetMatchingGroup(c21170025.syn,tp,LOCATION_HAND,0,nil,syncard)
		if mg3:GetCount()>0 then mg:Merge(mg3) end
	return mg
end
function c21170025.goal(g,tp,syncard,smat)
	if Duel.GetLocationCountFromEx(tp,tp,g,syncard)<=0 then return end
	if #g==2 and g:IsExists(c21170025.syn,2,nil) then return true end
	if g:IsExists(c21170025.syn,1,nil) and g:GetSum(Card.GetSynchroLevel,syncard)==5 then return true end
	return #g>=2 and g:GetSum(Card.GetSynchroLevel,syncard)==10 and Duel.CheckSynchroMaterial(syncard,c21170025.syn2,c21170025.syn2,1,10,smat,g) 
end
function c21170025.syncon()
	return	function(e,c,smat,mg1,min,max)
				if c==nil then return true end
				if c:IsType(TYPE_PENDULUM) and c:IsFaceup() then return false end
				local minc=2
				local maxc=10
				if min then
					local exct=0
					if min-exct>minc then minc=min-exct end
					if max-exct<maxc then maxc=max-exct end
					if minc>maxc then return false end
				end
				if smat and not smat:IsCanBeSynchroMaterial(c) then return false end
				local tp=c:GetControler()
				local mg
				local mgchk=false
				if mg1 then
					mg=mg1
					mgchk=true
				else
					mg=c21170025.GetSynMaterials(tp,c)
				end
				if smat~=nil then mg:AddCard(smat) end
				return mg:CheckSubGroup(c21170025.goal,minc,maxc,tp,c,smat)
			end
end
function c21170025.syntg()
	return	function(e,tp,eg,ep,ev,re,r,rp,chk,c,smat,mg1,min,max)
				local minc=2
				local maxc=10
				if min then
					local exct=0
					if min-exct>minc then minc=min-exct end
					if max-exct<maxc then maxc=max-exct end
					if minc>maxc then return false end
				end
				local mg
				local mgchk=false
				if mg1 then
					mg=mg1
					mgchk=true
				else
					mg=c21170025.GetSynMaterials(tp,c)
				end
				if smat~=nil then mg:AddCard(smat) end
				local cancel=Duel.IsSummonCancelable()
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SMATERIAL)
				local g=mg:SelectSubGroup(tp,c21170025.goal,cancel,minc,maxc,tp,c,smat)
				if g and g:GetCount()>0 then
					g:KeepAlive()
					e:SetLabelObject(g)
					return true
				else return false end
			end
end
function c21170025.con(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_SYNCHRO)
end
function c21170025.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_ONFIELD,nil)
	if chk==0 then return #g>0 end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,#g,0,0)
	Duel.SetOperationInfo(0,CATEGORY_ATKCHANGE,e:GetHandler(),1,0,#g*1000)
end
function c21170025.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_ONFIELD,nil)
	local s=Duel.Destroy(g,REASON_EFFECT)
	if s>0 and c:IsRelateToEffect(e) then
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetValue(s*1000)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
	c:RegisterEffect(e1)
	end
end