--合辛的最美死神
function c17337732.initial_effect(c)
	--synchro summon
	c:EnableReviveLimit()
	--[[aux.AddSynchroMixProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0x3f51),nil,nil,aux.Tuner(nil),1,283)
	--synchro level
	local ge0=Effect.CreateEffect(c)
	ge0:SetType(EFFECT_TYPE_SINGLE)
	ge0:SetCode(EFFECT_EXTRA_SYNCHRO_MATERIAL)
	ge0:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
	ge0:SetRange(LOCATION_HAND)
	ge0:SetValue(c17337732.matval)
	--effect grant
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
	e0:SetRange(LOCATION_EXTRA)
	e0:SetTargetRange(LOCATION_HAND,0)
	--e0:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x3f51))
	e0:SetLabelObject(ge0)
	c:RegisterEffect(e0)
	--redirect
	local ge1=Effect.CreateEffect(c)
	ge1:SetType(EFFECT_TYPE_FIELD)
	ge1:SetCode(EFFECT_TO_GRAVE_REDIRECT)
	ge1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	ge1:SetRange(0xff)
	ge1:SetTargetRange(0xff,0xff)
	ge1:SetTarget(c17337732.redtg)
	ge1:SetValue(LOCATION_DECKSHF)
	c:RegisterEffect(ge1)]]
	--synchro
	local e0=Effect.CreateEffect(c)
	e0:SetDescription(1164)
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetCode(EFFECT_SPSUMMON_PROC)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetRange(LOCATION_EXTRA)
	e0:SetCondition(c17337732.SynMixCondition())
	e0:SetTarget(c17337732.SynMixTarget())
	e0:SetOperation(c17337732.SynMixOperation())
	e0:SetValue(SUMMON_TYPE_SYNCHRO)
	c:RegisterEffect(e0)
	--change effect
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(17337732,0))
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,17337732)
	e1:SetCost(c17337732.cecost)
	--e1:SetTarget(c17337732.cetg)
	e1:SetOperation(c17337732.ceop)
	c:RegisterEffect(e1)
	--to hand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(17337732,1))
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,17337732+1)
	e2:SetCost(c17337732.thcost)
	e2:SetTarget(c17337732.thtg)
	e2:SetOperation(c17337732.thop)
	c:RegisterEffect(e2)
end
function c17337732.matval(e,c)
	return c:IsOriginalCodeRule(17337732)
end
function c17337732.redtg(e,c)
	return (c:GetReason()&REASON_SYNCHRO)==REASON_SYNCHRO and c:GetReasonCard():IsOriginalCodeRule(17337732)
end
function c17337732.costfilter(c,p)
	return c:IsAbleToHandAsCost() and Duel.IsExistingMatchingCard(Card.IsAbleToHand,p,0,LOCATION_ONFIELD,1,c)
end
function c17337732.cecost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c17337732.costfilter,tp,LOCATION_ONFIELD,0,1,nil,rp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local tc=Duel.SelectMatchingCard(tp,c17337732.costfilter,tp,LOCATION_ONFIELD,0,1,1,nil,rp):GetFirst()
	Duel.HintSelection(Group.FromCards(tc))
	Duel.SendtoHand(tc,nil,REASON_COST)
end
function c17337732.cetg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToHand,rp,0,LOCATION_ONFIELD,1,nil) end
end
function c17337732.ceop(e,tp,eg,ep,ev,re,r,rp)
	local g=Group.CreateGroup()
	Duel.ChangeTargetCard(ev,g)
	Duel.ChangeChainOperation(ev,c17337732.repop)
end
function c17337732.repop(e,tp,eg,ep,ev,re,r,rp)
	local p=1-tp
	Duel.Hint(HINT_SELECTMSG,p,HINTMSG_RTOHAND)
	local sg=Duel.SelectMatchingCard(p,Card.IsAbleToHand,p,LOCATION_ONFIELD,0,1,1,nil)
	if sg:GetCount()>0 then
		Duel.HintSelection(sg)
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
	end
end
function c17337732.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToExtraAsCost() end
	Duel.HintSelection(Group.FromCards(e:GetHandler()))
	Duel.SendtoDeck(e:GetHandler(),nil,SEQ_DECKTOP,REASON_COST)
end
function c17337732.thfilter(c,chk)
	return c:IsSetCard(0x3f51) and c:IsAbleToHand() and (chk==0 or aux.NecroValleyFilter()(c))
end
function c17337732.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(c17337732.thfilter,tp,LOCATION_GRAVE,0,1,c,0) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE)
end
function c17337732.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local tc=Duel.SelectMatchingCard(tp,c17337732.thfilter,tp,LOCATION_GRAVE,0,1,1,nil,1):GetFirst()
	if not tc then return end
	Duel.HintSelection(Group.FromCards(tc))
	Duel.SendtoHand(tc,nil,REASON_EFFECT)
end
--synchro
function c17337732.SynMixCondition()--f1,f2,f3,f4,minct,maxct,gc
	return  function(e,c,smat,mg1,min,max)
				if c==nil then return true end
				local tp=c:GetControler()
				local exg=Duel.GetMatchingGroup(Card.IsType,tp,LOCATION_HAND,0,nil,TYPE_MONSTER)
				local t={}
				if #exg>0 then
					for tc in aux.Next(exg) do
						local e1=Effect.CreateEffect(c)
						e1:SetType(EFFECT_TYPE_SINGLE)
						e1:SetCode(EFFECT_EXTRA_SYNCHRO_MATERIAL)
						e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
						e1:SetRange(LOCATION_HAND)
						e1:SetValue(1)
						tc:RegisterEffect(e1)
						table.insert(t,e1)
					end
				end
				if Duel.IsPlayerAffectedByEffect(tp,8173184) then
					Duel.RegisterFlagEffect(tp,8173184+1,0,0,1)
				end
				if smat and not smat:IsCanBeSynchroMaterial(c) then
					Duel.ResetFlagEffect(tp,8173184+1)
					if #t>0 then for _,te in ipairs(t) do te:Reset() end end
					return false
				end
				local mg
				local mgchk=false
				if mg1 then
					mg=mg1:Filter(Card.IsCanBeSynchroMaterial,nil,c)
					mgchk=true
				else
					mg=Auxiliary.GetSynMaterials(tp,c)
					--[[local mg2=Duel.GetMatchingGroup(Card.IsType,tp,LOCATION_HAND,0,nil,TYPE_MONSTER)
					if #mg2>0 then mg:Merge(mg2) end]]
				end
				if smat~=nil then mg:AddCard(smat) end
				local res=mg:IsExists(Auxiliary.SynMixFilter1,1,nil,aux.FilterBoolFunction(Card.IsSetCard,0x3f51),nil,nil,aux.Tuner(nil),1,283,c,mg,smat,gc,mgchk)
				Duel.ResetFlagEffect(tp,8173184+1)
				if #t>0 then for _,te in ipairs(t) do te:Reset() end end
				return res
			end
end
function c17337732.SynMixTarget()--f1,f2,f3,f4,minct,maxct,gc
	return  function(e,tp,eg,ep,ev,re,r,rp,chk,c,smat,mg1,min,max)
				local exg=Duel.GetMatchingGroup(Card.IsType,tp,LOCATION_HAND,0,nil,TYPE_MONSTER)
				local t={}
				if #exg>0 then
					for tc in aux.Next(exg) do
						local e1=Effect.CreateEffect(c)
						e1:SetType(EFFECT_TYPE_SINGLE)
						e1:SetCode(EFFECT_EXTRA_SYNCHRO_MATERIAL)
						e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
						e1:SetRange(LOCATION_HAND)
						e1:SetValue(1)
						tc:RegisterEffect(e1)
						table.insert(t,e1)
					end
				end
				::SynMixTargetSelectStart::
				if Duel.IsPlayerAffectedByEffect(tp,8173184) then
					Duel.RegisterFlagEffect(tp,8173184+1,0,0,1)
				end
				local g=Group.CreateGroup()
				local mg
				local mgchk=false
				if mg1 then
					mg=mg1:Filter(Card.IsCanBeSynchroMaterial,nil,c)
					mgchk=true
				else
					mg=Auxiliary.GetSynMaterials(tp,c)
					--[[local mg2=Duel.GetMatchingGroup(Card.IsType,tp,LOCATION_HAND,0,nil,TYPE_MONSTER)
					if #mg2>0 then mg:Merge(mg2) end]]
				end
				if smat~=nil then mg:AddCard(smat) end
				local c1
				local g4=Group.CreateGroup()
				local cancel=Duel.IsSummonCancelable()
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SMATERIAL)
				c1=mg:Filter(Auxiliary.SynMixFilter1,nil,aux.FilterBoolFunction(Card.IsSetCard,0x3f51),nil,nil,aux.Tuner(nil),1,283,c,mg,smat,gc,mgchk):SelectUnselect(g,tp,false,cancel,1,1)
				if not c1 then goto SynMixTargetSelectCancel end
				g:AddCard(c1)
				for i=0,283-1 do
					local mg2=mg:Clone()
					mg2=mg2:Filter(aux.Tuner,g,nil)
					local cg=mg2:Filter(Auxiliary.SynMixCheckRecursive,g4,tp,g4,mg2,i,1,283,c,g,smat,gc,mgchk)
					if cg:GetCount()==0 then break end
					local finish=Auxiliary.SynMixCheckGoal(tp,g4,1,i,c,g,smat,gc,mgchk)
					Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SMATERIAL)
					local c4=cg:SelectUnselect(g+g4,tp,finish,cancel,1,283)
					if not c4 then
						if finish then break
						else goto SynMixTargetSelectCancel end
					end
					if g:IsContains(c4) or g4:IsContains(c4) then goto SynMixTargetSelectStart end
					g4:AddCard(c4)
				end
				g:Merge(g4)
				if #t>0 then for _,te in ipairs(t) do te:Reset() end end
				if g:GetCount()>0 then
					g:KeepAlive()
					e:SetLabelObject(g)
					Duel.ResetFlagEffect(tp,8173184+1)
					return true
				end
				::SynMixTargetSelectCancel::
				if #t>0 then for _,te in ipairs(t) do te:Reset() end end
				Duel.ResetFlagEffect(tp,8173184+1)
				return false
			end
end
function c17337732.SynMixOperation()--f1,f2,f3,f4,minct,maxct,gc
	return  function(e,tp,eg,ep,ev,re,r,rp,c,smat,mg,min,max)
				local g=e:GetLabelObject()
				c:SetMaterial(g)
				local sg=g:Filter(Card.IsLocation,nil,LOCATION_HAND)
				if #sg>0 then
					for tc in aux.Next(sg) do
						local e1=Effect.CreateEffect(c)
						e1:SetType(EFFECT_TYPE_SINGLE)
						e1:SetCode(EFFECT_TO_GRAVE_REDIRECT)
						e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
						e1:SetValue(LOCATION_DECKSHF)
						e1:SetReset(RESET_EVENT+RESETS_REDIRECT)
						tc:RegisterEffect(e1)
					end
				end
				Duel.SendtoGrave(g,REASON_MATERIAL+REASON_SYNCHRO)
				g:DeleteGroup()
			end
end
