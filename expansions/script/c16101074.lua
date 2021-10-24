--融合替换者
local m=16101074
local cm=_G["c"..m]
function cm.initial_effect(c)
	c:EnableReviveLimit()
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(m)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetRange(0x7f)
	c:RegisterEffect(e0)
	if not cm.Fusion_R_Check then
		cm.Fusion_R_Check=true
		function aux.Fus_R_Filter(c,tp)
			local re=Duel.GetChainInfo(0,CHAININFO_TRIGGERING_EFFECT)
			return re and c:IsHasEffect(m) and c:IsControler(tp) and c:IsCanBeSpecialSummoned(re,0,tp,false,false)
		end
		_SpecialSummon=Duel.SpecialSummon
		_SpecialSummonStep=Duel.SpecialSummonStep
		_NegateActivation=Duel.NegateActivation
		function Duel.SpecialSummon(targets,sumtype,sumplayer,target_player,nocheck,nolimit,pos,...)
			local tp=sumplayer
			if sumtype~=SUMMON_TYPE_FUSION or (aux.GetValueType(targets)=="Group" and targets:GetCount()>1) then
				return _SpecialSummon(targets,sumtype,sumplayer,target_player,nocheck,nolimit,pos,...)
			end
			local rg=Duel.GetMatchingGroup(aux.Fus_R_Filter,sumplayer,LOCATION_HAND+LOCATION_DECK,0,nil,tp)
			if not rg then
				return _SpecialSummon(targets,sumtype,sumplayer,target_player,nocheck,nolimit,pos,...)
			elseif rg and Duel.SelectYesNo(tp,aux.Stringid(m,0))  then
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
				local tc=rg:Select(tp,1,1,nil):GetFirst()
				if _SpecialSummonStep(tc,sumtype,sumplayer,target_player,nocheck,nolimit,pos,...) then
					if aux.GetValueType(targets)=="Group" then
						targets=targets:GetFirst()
					end
					local code=targets:GetOriginalCodeRule()
					local e1=Effect.CreateEffect(tc)
					e1:SetType(EFFECT_TYPE_SINGLE)
					e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
					e1:SetCode(EFFECT_CHANGE_CODE)
					e1:SetValue(code)
					e1:SetReset(RESET_EVENT+0x7e0000)
					c:RegisterEffect(e1,true)
					if not targets:IsType(TYPE_TRAPMONSTER) then
						cid=tc:CopyEffect(code,RESET_EVENT+0x7e0000)
					end
				end
				Duel.SpecialSummonComplete()
			else
				return _SpecialSummon(targets,sumtype,sumplayer,target_player,nocheck,nolimit,pos,...)
			end
		end
		function Duel.SpecialSummonStep(targets,sumtype,sumplayer,target_player,nocheck,nolimit,pos,...)
			local tp=sumplayer
			if sumtype~=SUMMON_TYPE_FUSION then
				return _SpecialSummonStep(targets,sumtype,sumplayer,target_player,nocheck,nolimit,pos,...)
			end
			local rg=Duel.GetMatchingGroup(aux.Fus_R_Filter,sumplayer,LOCATION_HAND+LOCATION_DECK,0,nil,tp)
			if not rg then
				return _SpecialSummon(targets,sumtype,sumplayer,target_player,nocheck,nolimit,pos,...)
			elseif rg and Duel.SelectYesNo(tp,aux.Stringid(m,0))  then
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
				local tc=rg:Select(tp,1,1,nil):GetFirst()
				if _SpecialSummonStep(tc,sumtype,sumplayer,target_player,nocheck,nolimit,pos,...) then
					local code=targets:GetOriginalCodeRule()
					local e1=Effect.CreateEffect(tc)
					e1:SetType(EFFECT_TYPE_SINGLE)
					e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
					e1:SetCode(EFFECT_CHANGE_CODE)
					e1:SetValue(code)
					e1:SetReset(RESET_EVENT+0x7e0000)
					tc:RegisterEffect(e1,true)
					if not targets:IsType(TYPE_TRAPMONSTER) then
						cid=tc:CopyEffect(code,RESET_EVENT+0x7e0000)
					end
				end
			else
				return _SpecialSummon(targets,sumtype,sumplayer,target_player,nocheck,nolimit,pos,...)
			end
		end
	end
end
