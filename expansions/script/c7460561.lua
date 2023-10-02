--龙骑兵团灵衣-神数龙骑士
local s,id,o=GetID()
function s.initial_effect(c)
	--synchro summon
	c:EnableReviveLimit()
	local e0=Effect.CreateEffect(c)
	e0:SetDescription(1164)
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetCode(EFFECT_SPSUMMON_PROC)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetRange(LOCATION_EXTRA)
	e0:SetCondition(s.SynMixCondition)
	e0:SetTarget(s.SynMixTarget)
	e0:SetOperation(s.SynMixOperation)
	e0:SetValue(SUMMON_TYPE_SYNCHRO)
	c:RegisterEffect(e0)
	--copy effect
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCost(s.copycost)
	e1:SetOperation(s.copyop)
	c:RegisterEffect(e1)
end
function s.copyfilter(c)
	return c:IsSetCard(0x29) and not c:IsCode(id) and c:IsType(TYPE_MONSTER) and c:IsAbleToGraveAsCost()
end
function s.copycost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(s.copyfilter,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_EXTRA,0,1,nil) and c:GetFlagEffect(id)==0 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,s.copyfilter,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_EXTRA,0,1,1,nil)
	Duel.SendtoGrave(g,REASON_COST)
	e:SetLabel(g:GetFirst():GetOriginalCode())
	c:RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END+RESET_OPPO_TURN,0,1)
end
function s.copyop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local code=e:GetLabel()
	if c:IsRelateToEffect(e) and c:IsFaceup() then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END+RESET_OPPO_TURN)
		e1:SetCode(EFFECT_CHANGE_CODE)
		e1:SetValue(code)
		c:RegisterEffect(e1)
		local cregister=Card.RegisterEffect
		Card.RegisterEffect=function(card,effect,flag)
			if effect and effect:IsHasType(EFFECT_TYPE_IGNITION) then
				--spell speed 2
				if effect:IsHasType(EFFECT_TYPE_IGNITION) then
					effect:SetType(EFFECT_TYPE_QUICK_O)
					effect:SetCode(EVENT_FREE_CHAIN)
					effect:SetHintTiming(TIMING_DRAW_PHASE+TIMING_END_PHASE+TIMINGS_CHECK_MONSTER,TIMING_DRAW_PHASE+TIMING_END_PHASE+TIMINGS_CHECK_MONSTER)
				end
			end
			return cregister(card,effect,flag)
		end
		local cid=c:CopyEffect(code,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END+RESET_OPPO_TURN,1)
		Card.RegisterEffect=cregister
		local e2=Effect.CreateEffect(c)
		e2:SetDescription(aux.Stringid(id,2))
		e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e2:SetCode(EVENT_PHASE+PHASE_END)
		e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
		e2:SetCountLimit(1)
		e2:SetRange(LOCATION_MZONE)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END+RESET_OPPO_TURN)
		e2:SetLabelObject(e1)
		e2:SetLabel(cid)
		e2:SetCondition(s.rstcon)
		e2:SetOperation(s.rstop)
		c:RegisterEffect(e2)
	end
end
function s.rstcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==1-tp
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

-----------------synchro summon----------------------

function s.SynMixCondition(e,c,smat,mg1,min,max)
	if c==nil then return true end
	if c:IsType(TYPE_PENDULUM) and c:IsFaceup() then return false end
	local minc=2
	local maxc=99
	if smat and not smat:IsCanBeSynchroMaterial(c) then return false end
	local tp=c:GetControler()
	local mg
	local mgchk=false
	if mg1 then
		mg=mg1
		mgchk=true
	else
		mg=s.GetSynMaterials(tp,c)
	end
	if smat~=nil then mg:AddCard(smat) end
	return mg:IsExists(aux.SynMixFilter1,1,nil,aux.NonTuner(Card.IsRace,RACE_DRAGON),nil,nil,aux.Tuner(Card.IsRace,RACE_DRAGON),2,99,c,mg,smat,gc,mgchk)
end
function s.SynMaterialFilterExtra(c,syncard)
	return c.IsCanBeSynchroMaterial(syncard) and c:IsSetCard(0x29)
end
function s.GetSynMaterials(tp,syncard)
	local mg=Duel.GetSynchroMaterial(tp):Filter(aux.SynMaterialFilter,nil,syncard)
	if mg:IsExists(Card.GetHandSynchro,1,nil) then
		local mg2=Duel.GetMatchingGroup(Card.IsCanBeSynchroMaterial,tp,LOCATION_HAND,0,nil,syncard)
		if mg2:GetCount()>0 then mg:Merge(mg2) end
	end
	if Duel.GetFlagEffect(tp,id)==0 then
		local mg3=Duel.GetMatchingGroup(s.SynMaterialFilterExtra,tp,LOCATION_GRAVE,0,nil,syncard)
		if mg3:GetCount()>0 then mg:Merge(mg3) end
	end
	return mg
end
function s.SynMaterialFilterFilter(c,lv,syncard)
	return c:GetSynchroLevel(syncard)<=lv
end
function s.SynMixTarget(e,tp,eg,ep,ev,re,r,rp,chk,c,smat,mg1,min,max)
	local minc=2
	local maxc=99
	::SynMixTargetSelectStart::
	local g=Group.CreateGroup()
	local mg
	local mgchk=false
	if mg1 then
		mg=mg1
		mgchk=true
	else
		mg=s.GetSynMaterials(tp,c)
	end
	if smat~=nil then mg:AddCard(smat) end
	local c1
	local c2
	local c3
	local cancel=Duel.IsSummonCancelable()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SMATERIAL)
	c1=mg:Filter(aux.SynMixFilter1,nil,aux.NonTuner(Card.IsRace,RACE_DRAGON),nil,nil,aux.Tuner(Card.IsRace,RACE_DRAGON),2,99,c,mg,smat,gc,mgchk):SelectUnselect(g,tp,false,cancel,1,1)
	if not c1 then return false end
	g:AddCard(c1)
	local g4=Group.CreateGroup()
	for i=0,maxc-1 do
		local mg2=mg:Clone()
		mg2=mg2:Filter(aux.Tuner(Card.IsRace,RACE_DRAGON),g,c,c1,c2,c3)
		local cg=mg2:Filter(aux.SynMixCheckRecursive,g4,tp,g4,mg2,i,2,99,c,g,smat,gc,mgchk)
		if cg:GetCount()==0 then break end
		local finish=aux.SynMixCheckGoal(tp,g4,minc,i,c,g,smat,gc,mgchk)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SMATERIAL)
		local c4=cg:SelectUnselect(g+g4,tp,finish,cancel,2,99)
		if not c4 then
			if finish then break
			else return false end
		end
		if g:IsContains(c4) or g4:IsContains(c4) then goto SynMixTargetSelectStart end
		g4:AddCard(c4)
	end
	g:Merge(g4)
	if g:GetCount()>0 then
		g:KeepAlive()
		e:SetLabelObject(g)
		return true
	else return false end
end
function s.SynMixOperation(e,tp,eg,ep,ev,re,r,rp,c,smat,mg,min,max)
	local g=e:GetLabelObject()
	c:SetMaterial(g)
	local reg=g:Filter(Card.IsLocation,nil,LOCATION_GRAVE)
	if #reg>0 then
		Duel.Remove(reg,POS_FACEUP,REASON_MATERIAL+REASON_SYNCHRO)
		Duel.RegisterFlagEffect(tp,id,RESET_PHASE+PHASE_END,0,1)
		g:Sub(reg)
		if #g<=0 then return false end
	end
	Duel.SendtoGrave(g,REASON_MATERIAL+REASON_SYNCHRO)
	g:DeleteGroup()
end
