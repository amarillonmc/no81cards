--魔力训练场
local cm,m=GetID()
function cm.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_CANNOT_INACTIVATE)
	e4:SetValue(cm.effectfilter)
	e4:SetRange(LOCATION_SZONE)
	c:RegisterEffect(e4)
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetCode(EFFECT_CANNOT_DISEFFECT)
	e5:SetValue(cm.effectfilter)
	e5:SetRange(LOCATION_SZONE)
	c:RegisterEffect(e5)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_CHAIN_SOLVING)
	e2:SetCondition(cm.discon)
	e2:SetOperation(cm.disop)
	e2:SetRange(LOCATION_SZONE)
	c:RegisterEffect(e2)
	if not cm.global_check then
		cm.global_check=true
		local _AddCounter=Card.AddCounter
		function Card.AddCounter(c,typ,ct,...)
			local tp=c:GetControler()
			local sg=Duel.GetMatchingGroup(function(c) return c:GetOriginalCode()==m and c:IsSSetable() end,c:GetControler(),LOCATION_DECK,0,nil)
			if c:IsHasEffect(EFFECT_COUNTER_LIMIT+0x1) and #sg>0 and Duel.SelectEffectYesNo(tp,c,aux.Stringid(m,0)) then
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
				local g=Duel.SelectMatchingCard(tp,function(c) return c:GetOriginalCode()==m and c:IsSSetable() end,tp,LOCATION_DECK,0,1,1,nil)
				local tc=g:GetFirst()
				Duel.SSet(tp,tc)
				return false
			end
			return _AddCounter(c,typ,ct,...)
		end
	end
end
function cm.effectfilter(e,ct)
	local p=e:GetHandler():GetControler()
	local te=Duel.GetChainInfo(ct,CHAININFO_TRIGGERING_EFFECT)
	return p==tp and te:GetHandler():IsHasEffect(EFFECT_COUNTER_LIMIT+0x1)
end
function cm.discon(e,tp,eg,ep,ev,re,r,rp)
	return rp==tp and re:GetHandler():IsHasEffect(EFFECT_COUNTER_LIMIT+0x1)
end
function cm.spfilter2(c,e)
	return not c:IsImmuneToEffect(e)
end
function cm.spfilter3(c,e,tp,m,f,chkf)
	return c:IsType(TYPE_FUSION) and (not f or f(c))
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false) and c:CheckFusionMaterial(m,nil,chkf)
end
function cm.fcheck1(fid)
	return  function(tp,sg,fc)
				return sg:IsExists(cm.ffilter,1,nil)
			end
end
function cm.filter0(c)
	return c:IsType(TYPE_MONSTER) and c:IsCanBeFusionMaterial() and c:IsAbleToGrave()
end
function cm.disop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetLabelObject(re)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetOperation(cm.spop)
	e1:Reset(RESET_CHAIN)
	Duel.RegisterEffect(e1,tp)
	local op0=re:GetOperation() or (function() end)
	local op2=function(e,tp,eg,ep,ev,re,r,rp)
				e:SetOperation(op0)
				op0(e,tp,eg,ep,ev,re,r,rp)
				local g=Duel.GetMatchingGroup(cm.ffilter,0,LOCATION_MZONE,LOCATION_MZONE,nil)
				if #g==0 then return end
				local c=e:GetHandler()
				local chkf=tp
				local mg1=Duel.GetFusionMaterial(tp):Filter(cm.spfilter2,nil,e)
				local mg2=Duel.GetMatchingGroup(cm.filter0,tp,LOCATION_DECK,0,nil)
				mg1:Merge(mg2)
				aux.FCheckAdditional=cm.fcheck1(c:GetFieldID())
				local sg1=Duel.GetMatchingGroup(cm.spfilter3,tp,LOCATION_EXTRA,0,nil,e,tp,mg1,nil,chkf)
				local mg2=nil
				local sg2=nil
				local ce=Duel.GetChainMaterial(tp)
				if ce~=nil then
					local fgroup=ce:GetTarget()
					mg2=fgroup(ce,e,tp)
					local mf=ce:GetValue()
					sg2=Duel.GetMatchingGroup(cm.spfilter3,tp,LOCATION_EXTRA,0,nil,e,tp,mg2,mf,chkf)
				end
				if sg1:GetCount()>0 or (sg2~=nil and sg2:GetCount()>0) then
					Duel.BreakEffect()
					local sg=sg1:Clone()
					if sg2 then sg:Merge(sg2) end
					Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
					local tg=sg:Select(tp,1,1,nil)
					local tc=tg:GetFirst()
					if sg1:IsContains(tc) and (sg2==nil or not sg2:IsContains(tc) or not Duel.SelectYesNo(tp,ce:GetDescription())) then
						local mat1=Duel.SelectFusionMaterial(tp,tc,mg1,nil,chkf)
						tc:SetMaterial(mat1)
						Duel.SendtoGrave(mat1,REASON_EFFECT+REASON_MATERIAL+REASON_FUSION)
						Duel.BreakEffect()
						Duel.SpecialSummon(tc,SUMMON_TYPE_FUSION,tp,tp,false,false,POS_FACEUP)
					else
						local mat2=Duel.SelectFusionMaterial(tp,tc,mg2,nil,chkf)
						local fop=ce:GetOperation()
						fop(ce,e,tp,tc,mat2)
					end
					tc:CompleteProcedure()
					if Duel.IsExistingMatchingCard(Card.IsSummonable,tp,LOCATION_HAND+LOCATION_MZONE,0,1,nil,true,nil)
						and Duel.SelectYesNo(tp,aux.Stringid(21291696,2)) then
						Duel.BreakEffect()
						Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SUMMON)
						local sg=Duel.SelectMatchingCard(tp,Card.IsSummonable,tp,LOCATION_HAND+LOCATION_MZONE,0,1,1,nil,true,nil)
						if sg:GetCount()>0 then
							Duel.Summon(tp,sg:GetFirst(),true,nil)
						end
					end
				end
				aux.FCheckAdditional=nil
			end
	re:SetOperation(op2)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetCode(EVENT_CHAIN_SOLVED)
	e1:SetCountLimit(1)
	e1:SetLabel(ev)
	e1:SetCondition(function(e,tp,eg,ep,ev,re,r,rp) return ev==e:GetLabel() end)
	e1:SetOperation(function(e,tp,eg,ep,ev,re,r,rp)
						re:SetOperation(op0)
						local g=Duel.GetMatchingGroup(cm.ffilter,0,LOCATION_MZONE,LOCATION_MZONE,nil)
						for tc in aux.Next(g) do tc:ResetFlagEffect(m) end
					end)
	e1:SetReset(RESET_CHAIN)
	Duel.RegisterEffect(e1,tp)
	local e2=e1:Clone()
	e2:SetCode(EVENT_CHAIN_NEGATED)
	Duel.RegisterEffect(e2,tp)
end
function cm.ffilter(c)
	return c:GetFlagEffect(m+1)>0
end
function cm.filter2(c,re)
	return c:IsLocation(LOCATION_MZONE) and c:GetReasonEffect()==re
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	local g=eg:Filter(cm.filter2,nil,e:GetLabelObject())
	for tc in aux.Next(g) do
		tc:RegisterFlagEffect(m+1,RESET_CHAIN+RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET,0,1)
	end
end