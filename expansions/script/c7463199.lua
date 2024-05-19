--贤者之魔导书
local s,id,o=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_FUSION_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(TIMING_END_PHASE,TIMING_END_PHASE)
	e1:SetCountLimit(1,id+EFFECT_COUNT_CODE_OATH)
	e1:SetCost(s.cost)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
end
function s.cffilter(c)
	return c:IsSetCard(0x106e) and not c:IsPublic()
end
function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.cffilter,tp,LOCATION_HAND,0,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local g=Duel.SelectMatchingCard(tp,s.cffilter,tp,LOCATION_HAND,0,1,1,e:GetHandler())
	Duel.ConfirmCards(1-tp,g)
	Duel.ShuffleHand(tp)
	--[[--remain field
	local c=e:GetHandler()
	local cid=Duel.GetChainInfo(0,CHAININFO_CHAIN_ID)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_REMAIN_FIELD)
	e1:SetProperty(EFFECT_FLAG_OATH)
	e1:SetReset(RESET_CHAIN)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_CHAIN_DISABLED)
	e2:SetOperation(s.tgop)
	e2:SetLabel(cid)
	e2:SetReset(RESET_CHAIN)
	Duel.RegisterEffect(e2,tp)]]
end
function s.tgop(e,tp,eg,ep,ev,re,r,rp)
	local cid=Duel.GetChainInfo(ev,CHAININFO_CHAIN_ID)
	if cid~=e:GetLabel() then return end
	if e:GetOwner():IsRelateToChain(ev) then
		e:GetOwner():CancelToGrave(false)
	end
end
function s.spfilter(c,e,tp)
	return c:IsSetCard(0x150) and c:IsType(TYPE_MONSTER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return --e:IsCostChecked() and  
		Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,e:GetHandler(),1,tp,LOCATION_HAND)
end
function s.eqlimit(e,c)
	return e:GetOwner()==c
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsLocation(LOCATION_SZONE) then return end
	if not c:IsRelateToEffect(e) or c:IsStatus(STATUS_LEAVE_CONFIRMED) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,s.spfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
	local tc=g:GetFirst()
	if tc and Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)~=0 then
		Duel.Equip(tp,c,tc)
		--Add Equip limit
		local e0=Effect.CreateEffect(tc)
		e0:SetType(EFFECT_TYPE_SINGLE)
		e0:SetCode(EFFECT_EQUIP_LIMIT)
		e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e0:SetReset(RESET_EVENT+RESETS_STANDARD)
		e0:SetValue(s.eqlimit)
		c:RegisterEffect(e0)
		--copy
		local code=tc:GetOriginalCode()
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetCode(EFFECT_CHANGE_CODE)
		e1:SetValue(code)
		c:RegisterEffect(e1)
		local cregister=Card.RegisterEffect
		Card.RegisterEffect=function(card,effect,flag)
			if effect and effect:IsHasType(EFFECT_TYPE_IGNITION) then
				--spell speed 2
				if effect:IsHasType(EFFECT_TYPE_IGNITION) then
					local effect2=effect:Clone()
					effect2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
					effect2:SetCode(EVENT_CHAINING)
					effect2:SetLabelObject(effect)
					effect2:SetCountLimit(9999)
					local con=effect2:GetCondition()
					local tg=effect2:GetTarget()
					local op=effect2:GetOperation()
					effect2:SetCondition(function(e,tp,eg,ep,ev,re,r,rp)
						local c=e:GetHandler()
						local le=e:GetLabelObject()
						return c:GetEquipTarget() and rp==1-tp 
							and Effect.CheckCountLimit(le,tp) 
							and (not con or con(e,tp,eg,ep,ev,re,r,rp))
					end)
					effect2:SetTarget(
					function(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
						if chk==0 then return not tg or tg(e,tp,eg,ep,ev,re,r,1-tp,0) end
					end)
					effect2:SetOperation(
					function(e,tp,eg,ep,ev,re,r,rp)
						local le=e:GetLabelObject()
						if 
						Effect.CheckCountLimit(le,tp) and 
						(not tg or tg(e,tp,eg,ep,ev,re,r,1-tp,0)) and Duel.SelectEffectYesNo(tp,e:GetHandler(),aux.Stringid(id,1)) then
							Duel.Hint(HINT_CARD,0,id)
							le:UseCountLimit(tp)
							--
							BlackLouts_SpellBook_targetcard=Group.CreateGroup()
							local chaininfo={}
							local _SelectTarget=Duel.SelectTarget
							Duel.SelectTarget=(function(sel_p,f,p,self,o,min,max,c_g_n,...)
								local tgroup=Duel.SelectMatchingCard(sel_p,s.TargetFilter(f),p,self,o,min,max,c_g_n,...)
								for tc in aux.Next(tgroup) do
									tc:CreateEffectRelation(e)
								end
								Duel.HintSelection(tgroup)
								BlackLouts_SpellBook_targetcard:Merge(tgroup)
								return tgroup
							end)
							local _SetOperationInfo=Duel.SetOperationInfo
							Duel.SetOperationInfo=(function(chainc,category,targets,count,tg_pl,tg_param)
								return 
							end)
							local _GetChainInfo=Duel.GetChainInfo
							Duel.GetChainInfo=(function(chainc,...)
								local val={...}
								local returninfo={}
								if #val==0 then return false end
								for i=1,#val do
									if val[i]==CHAININFO_TARGET_CARDS then
										returninfo[i]=BlackLouts_SpellBook_targetcard
									else
										returninfo[i]=0
									end
								end
								return table.unpack(returninfo)
							end)
							local _GetFirstTarget=Duel.GetFirstTarget
							Duel.GetFirstTarget=(function()
								return BlackLouts_SpellBook_targetcard:GetFirst()
							end)
							--
							tg(e,tp,eg,ep,ev,re,r,rp,1)
							op(e,tp,eg,ep,ev,re,r,rp)
							--
							Duel.SelectTarget=_SelectTarget
							Duel.SetOperationInfo=_SetOperationInfo
							Duel.GetChainInfo=_GetChainInfo
							Duel.GetFirstTarget=_GetFirstTarget
						end
					end)
					cregister(card,effect2,flag)
				end
			end
			return cregister(card,effect,flag)
		end
		c:CopyEffect(code,RESET_EVENT+RESETS_STANDARD,1)
		Card.RegisterEffect=cregister
	elseif c:IsRelateToEffect(e) and not c:IsStatus(STATUS_LEAVE_CONFIRMED) then
		c:CancelToGrave(false)
	end
end
function s.TargetFilter(f)
	return  function(target,...)
				return (not f or f(target,...)) and target:IsCanBeEffectTarget()
			end
end
