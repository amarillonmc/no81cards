--天启录的修罗鸟
function c21170020.initial_effect(c)
	c:EnableReviveLimit()
	local e0=Effect.CreateEffect(c)
	e0:SetDescription(1164)
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetCode(EFFECT_SPSUMMON_PROC)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetRange(LOCATION_EXTRA)
	e0:SetCondition(c21170020.syncon())
	e0:SetTarget(c21170020.syntg())
	e0:SetOperation(Auxiliary.SynOperation(nil,nil,nil,nil))
	e0:SetValue(SUMMON_TYPE_SYNCHRO)
	c:RegisterEffect(e0)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_UPDATE_DEFENSE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(0,LOCATION_MZONE)
	e1:SetValue(-3200)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(21170020,0))
	e2:SetCategory(CATEGORY_POSITION)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,21170020)
	e2:SetTarget(c21170020.tg2)
	e2:SetOperation(c21170020.op2)
	c:RegisterEffect(e2)	
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(21170020,1))
	e3:SetCategory(CATEGORY_REMOVE+CATEGORY_DAMAGE)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_DAMAGE_STEP_END)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,21170021)
	e3:SetCondition(c21170020.con3)
	e3:SetTarget(c21170020.tg3)
	e3:SetOperation(c21170020.op3)
	c:RegisterEffect(e3)
end
function c21170020.syn(c,syncard)
	return c:IsLocation(LOCATION_HAND) and c:IsPublic() and c:IsSetCard(0x6917) and c:GetOriginalType()==TYPE_SPELL
end
function c21170020.syn2(c)
	return c:IsRace(RACE_FIEND)
end
function c21170020.GetSynMaterials(tp,syncard)
	local mg=Duel.GetSynchroMaterial(tp):Filter(Auxiliary.SynMaterialFilter,nil,syncard):Filter(Card.IsRace,nil,RACE_FIEND)
	if mg:IsExists(Card.GetHandSynchro,1,nil) then
		local mg2=Duel.GetMatchingGroup(Card.IsCanBeSynchroMaterial,tp,LOCATION_HAND,0,nil,syncard)
		if mg2:GetCount()>0 then mg:Merge(mg2) end
	end
	local mg3=Duel.GetMatchingGroup(c21170020.syn,tp,LOCATION_HAND,0,nil,syncard)
		if mg3:GetCount()>0 then mg:Merge(mg3) end
	return mg
end
function c21170020.goal(g,tp,syncard,smat)
	if Duel.GetLocationCountFromEx(tp,tp,g,syncard)<=0 then return end
	if #g==2 and g:IsExists(c21170020.syn,2,nil) then return true end
	if g:IsExists(c21170020.syn,1,nil) and g:GetSum(Card.GetSynchroLevel,syncard)==5 then return true end
	return #g>=2 and g:GetSum(Card.GetSynchroLevel,syncard)==10 and Duel.CheckSynchroMaterial(syncard,c21170020.syn2,c21170020.syn2,1,10,smat,g) 
end
function c21170020.syncon()
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
					mg=c21170020.GetSynMaterials(tp,c)
				end
				if smat~=nil then mg:AddCard(smat) end
				return mg:CheckSubGroup(c21170020.goal,minc,maxc,tp,c,smat)
			end
end
function c21170020.syntg()
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
					mg=c21170020.GetSynMaterials(tp,c)
				end
				if smat~=nil then mg:AddCard(smat) end
				local cancel=Duel.IsSummonCancelable()
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SMATERIAL)
				local g=mg:SelectSubGroup(tp,c21170020.goal,cancel,minc,maxc,tp,c,smat)
				if g and g:GetCount()>0 then
					g:KeepAlive()
					e:SetLabelObject(g)
					return true
				else return false end
			end
end
function c21170020.q(c)
	return c:IsPosition(POS_FACEUP_ATTACK) and c:IsCanChangePosition() 
end
function c21170020.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c21170020.q,tp,0,LOCATION_MZONE,1,nil) end
	local g=Duel.GetMatchingGroup(c21170020.q,tp,0,LOCATION_MZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_POSITION,g,#g,0,0)
end
function c21170020.op2(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c21170020.q,tp,0,LOCATION_MZONE,nil)
	if #g>0 then
	Duel.ChangePosition(g,POS_FACEUP_DEFENSE)
	end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_PIERCE)
	e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x6917))
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c21170020.con3(e,tp,eg,ep,ev,re,r,rp)
	local a,d=Duel.GetBattleMonster(tp)
	if not a or not d then return false end
	e:SetLabelObject(d)
	return a:IsSetCard(0x6917) and d:IsRelateToBattle() and d:IsOnField()
end
function c21170020.tg3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetLabelObject():IsAbleToRemove() and e:GetLabelObject():GetBaseAttack()>0 end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,e:GetLabelObject(),1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,e:GetLabelObject():GetBaseAttack())
end
function c21170020.op3(e,tp,eg,ep,ev,re,r,rp)
	local bc=e:GetLabelObject()
	if bc:IsRelateToBattle() and Duel.Remove(bc,POS_FACEUP,REASON_EFFECT)>0 and bc:IsLocation(LOCATION_REMOVED) then
	Duel.Damage(1-tp,e:GetLabelObject():GetBaseAttack(),REASON_EFFECT)
	end
end