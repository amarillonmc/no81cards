-- 特里同君主 米兰-帕里奥洛格斯
local cm,m,o=GetID()
function cm.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_CUSTOM+m)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(cm.spcon)
	--e1:SetTarget(cm.sptg)
	e1:SetOperation(cm.spop)
	c:RegisterEffect(e1)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_CHAIN_END)
	e1:SetRange(LOCATION_MZONE)
	e1:SetOperation(cm.bkop)
	c:RegisterEffect(e1)
	if not cm.global_check then
		cm.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_CHAINING)
		ge1:SetOperation(cm.checkop)
		Duel.RegisterEffect(ge1,0)
		local ge2=Effect.CreateEffect(c)
		ge2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge2:SetCode(EVENT_CHAIN_ACTIVATING)
		ge2:SetCountLimit(1,EFFECT_COUNT_CODE_CHAIN)
		ge2:SetOperation(cm.chkop)
		Duel.RegisterEffect(ge2,0)
	end
end
function cm.checkop(e,tp,eg,ep,ev,re,r,rp)
	--local tp=e:GetHandlerPlayer()
	Duel.RegisterFlagEffect(0,m,RESET_CHAIN,0,1)
end
function cm.chkop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFlagEffect(tp,m+10000000)==0 then
		Duel.RaiseEvent(e:GetHandler(),EVENT_CUSTOM+m,e,r,rp,ep,ev)
		Duel.RegisterFlagEffect(tp,m+10000000,RESET_CHAIN,0,1)
	end
end
function cm.filter0(c,e)
	return not c:IsImmuneToEffect(e)
end
function cm.filter(c,e,tp,m,f,chkf)
	return c:IsType(TYPE_FUSION) and (not f or f(c))
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false) and c:CheckFusionMaterial(m,nil,chkf)
end
function cm.spcon(e,tp,eg,ep,ev,re,r,rp)
	local tp=e:GetHandlerPlayer()
	local num=Duel.GetFlagEffect(0,m)
	local g=Duel.GetDecktopGroup(tp,num)

	local mg1=Duel.GetFusionMaterial(tp)
	local res=Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg1,nil,chkf)
	if not res then
		local ce=Duel.GetChainMaterial(tp)
		if ce~=nil then
			local fgroup=ce:GetTarget()
			local mg2=fgroup(ce,e,tp)
			local mf=ce:GetValue()
			res=Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg2,mf,chkf)
		end
	end
	return res and g:GetCount()>=num and g:IsExists(Card.IsAbleToHand,1,nil) and Duel.GetMZoneCount(tp)>0
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local num=Duel.GetFlagEffect(0,m)
	if Duel.GetMZoneCount(tp)>0 and Duel.SelectYesNo(tp,aux.Stringid(m,0)) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)~=0 then
		Duel.ConfirmDecktop(tp,num)
		local g=Duel.GetDecktopGroup(tp,num):Filter(Card.IsSetCard,nil,0x9622)
		if g:GetCount()>0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			local sg=g:Select(tp,1,1,nil)
			if sg:GetFirst():IsAbleToHand() then
				if Duel.SendtoHand(sg,nil,REASON_EFFECT)~=0 then
					Duel.ConfirmCards(1-tp,sg)
					Duel.ShuffleHand(tp)
					local chkf=tp
					local mg1=Duel.GetFusionMaterial(tp):Filter(cm.filter0,nil,e)
					local sg1=Duel.GetMatchingGroup(cm.filter,tp,LOCATION_EXTRA,0,nil,e,tp,mg1,nil,chkf)
					local mg2=nil
					local sg2=nil
					local ce=Duel.GetChainMaterial(tp)
					if ce~=nil then
						local fgroup=ce:GetTarget()
						mg2=fgroup(ce,e,tp)
						local mf=ce:GetValue()
						sg2=Duel.GetMatchingGroup(cm.filter,tp,LOCATION_EXTRA,0,nil,e,tp,mg2,mf,chkf)
					end
					if sg1:GetCount()>0 or (sg2~=nil and sg2:GetCount()>0) then
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
					end
				end
			else
				Duel.SendtoGrave(sg,REASON_RULE)
			end
			Duel.ShuffleDeck(tp)
		else
			Duel.ShuffleDeck(tp)
		end
	end
end
function cm.bkop(e,tp,eg,ep,ev,re,r,rp)
	local tp=e:GetHandlerPlayer()
	Duel.SendtoHand(e:GetHandler(),tp,REASON_EFFECT)
end