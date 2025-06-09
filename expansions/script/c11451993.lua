--空之舞姬
local cm,m=GetID()
function cm.initial_effect(c)
	--remove
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_REMOVE+CATEGORY_TODECK)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_HAND+LOCATION_MZONE+LOCATION_GRAVE)
	e3:SetHintTiming(0,TIMING_MAIN_END)
	e3:SetCountLimit(1,EFFECT_COUNT_CODE_CHAIN)
	e3:SetCondition(cm.scon)
	e3:SetTarget(cm.stg)
	e3:SetOperation(cm.sop)
	c:RegisterEffect(e3)
end
function cm.scon(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	return (ph==PHASE_MAIN1 or ph==PHASE_MAIN2)
end
function cm.stg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToRemove() end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,c,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,tp,LOCATION_REMOVED)
end
function cm.sop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.Remove(c,POS_FACEUP,REASON_EFFECT)>0 and c:IsLocation(LOCATION_REMOVED) then Duel.SendtoDeck(c,nil,2,REASON_EFFECT) end
	local t=Duel.GetTurnCount()
	local _SendtoHand=Duel.SendtoHand
	local _Draw=Duel.Draw
	local _DiscardDeck=Duel.DiscardDeck
	local _SendtoGrave=Duel.SendtoGrave
	local _SpecialSummon=Duel.SpecialSummon
	local _SpecialSummonStep=Duel.SpecialSummonStep
	Duel.SendtoHand=function(g,p,r,...)
						if aux.GetValueType(g)=="Card" then g=Group.FromCards(g) end
						if aux.GetValueType(g)~="Group" then return _SendtoHand(g,p,r,...) end
						local dg=g:Filter(Card.IsLocation,nil,LOCATION_DECK):Filter(Card.IsAbleToRemove,nil)
						if t==Duel.GetTurnCount() and r&REASON_EFFECT>0 and #dg>0 then
							Duel.Remove(dg,POS_FACEUP,r,...)
							g=(g-dg)+dg:Filter(Card.IsLocation,nil,LOCATION_REMOVED)
							return _SendtoHand(g,p,r,...)
						end
						return _SendtoHand(g,p,r,...)
					end
	Duel.Draw=function(p,ct,r,...)
						local dg=Duel.GetDecktopGroup(p,ct):Filter(Card.IsAbleToRemove,nil)
						if t==Duel.GetTurnCount() and r&REASON_EFFECT>0 and #dg==#Duel.GetDecktopGroup(p,ct) then
							Duel.DisableShuffleCheck()
							Duel.Remove(dg,POS_FACEUP,r)
							dg=dg:Filter(Card.IsLocation,nil,LOCATION_REMOVED)
							local res=_SendtoHand(dg,p,r)
							if res>0 then Duel.ConfirmCards(1-p,Duel.GetOperatedGroup():Filter(Card.IsLocation,nil,LOCATION_HAND)) end
							return res
						end
						return _Draw(p,ct,r,...)
					end
	Duel.DiscardDeck=function(p,ct,r,...)
						local dg=Duel.GetDecktopGroup(p,ct):Filter(Card.IsAbleToRemove,nil)
						if t==Duel.GetTurnCount() and r&REASON_EFFECT>0 and #dg==#Duel.GetDecktopGroup(p,ct) then
							Duel.DisableShuffleCheck()
							Duel.Remove(dg,POS_FACEUP,r)
							dg=dg:Filter(Card.IsLocation,nil,LOCATION_REMOVED)
							return _SendtoGrave(dg,r)
						end
						return _DiscardDeck(p,ct,r,...)
					end
	Duel.SendtoGrave=function(g,r,...)
						if aux.GetValueType(g)=="Card" then g=Group.FromCards(g) end
						if aux.GetValueType(g)~="Group" then return _SendtoGrave(g,r,...) end
						local dg=g:Filter(Card.IsLocation,nil,LOCATION_DECK):Filter(Card.IsAbleToRemove,nil)
						if t==Duel.GetTurnCount() and r&REASON_EFFECT>0 and #dg>0 then
							Duel.Remove(dg,POS_FACEUP,r,...)
							g=(g-dg)+dg:Filter(Card.IsLocation,nil,LOCATION_REMOVED)
							return _SendtoGrave(g,r|REASON_RETURN,...)
						end
						return _SendtoGrave(g,r,...)
					end
	Duel.SpecialSummon=function(g,st,sp,top,...)
						if aux.GetValueType(g)=="Card" then g=Group.FromCards(g) end
						if aux.GetValueType(g)~="Group" then return _SpecialSummon(g,st,sp,top,...) end
						local dg=g:Filter(Card.IsLocation,nil,LOCATION_DECK):Filter(Card.IsAbleToRemove,nil)
						if t==Duel.GetTurnCount() and #dg>0 then
							Duel.Remove(dg,POS_FACEUP,REASON_EFFECT,sp)
							g=(g-dg)+dg:Filter(Card.IsLocation,nil,LOCATION_REMOVED)
							return _SpecialSummon(g,st,sp,top,...)
						end
						return _SpecialSummon(g,st,sp,top,...)
					end
	Duel.SpecialSummonStep=function(c,st,sp,top,...)
						if aux.GetValueType(c)~="Card" then return _SpecialSummonStep(c,st,sp,top,...) end
						local dg=Group.FromCards(c):Filter(Card.IsLocation,nil,LOCATION_DECK):Filter(Card.IsAbleToRemove,nil)
						if t==Duel.GetTurnCount() and #dg>0 then
							Duel.Remove(dg,POS_FACEUP,REASON_EFFECT,sp)
							g=(g-dg)+dg:Filter(Card.IsLocation,nil,LOCATION_REMOVED)
							if #g>0 then return _SpecialSummonStep(c,st,sp,top,...) end
							return false
						end
						return _SpecialSummonStep(c,st,sp,top,...)
					end
	local _IsAbleToHand=Card.IsAbleToHand
	local _IsPlayerCanDraw=Duel.IsPlayerCanDraw
	local _IsPlayerCanSendtoHand=Duel.IsPlayerCanSendtoHand
	local _IsPlayerCanDiscardDeck=Duel.IsPlayerCanDiscardDeck
	local _IsAbleToGrave=Card.IsAbleToGrave
	local _IsPlayerCanSendtoGrave=Duel.IsPlayerCanSendtoGrave
	local _IsCanBeSpecialSummoned=Card.IsCanBeSpecialSummoned
	local _IsPlayerCanSpecialSummon=Duel.IsPlayerCanSpecialSummon
	Card.IsAbleToHand=function(c,...)
						if aux.GetValueType(c)~="Card" then return _IsAbleToHand(c,...) end
						local dg=Group.FromCards(c):Filter(Card.IsLocation,nil,LOCATION_DECK):Filter(Card.IsAbleToRemove,nil)
						if t==Duel.GetTurnCount() and #dg>0 and c:IsAbleToRemove() then return true end
						return _IsAbleToHand(c,...)
					end
	Duel.IsPlayerCanDraw=function(p,ct,...)
						local dg=Duel.GetDecktopGroup(p,ct):Filter(Card.IsAbleToRemove,nil)
						if t==Duel.GetTurnCount() and r&REASON_EFFECT>0 and #dg==ct then return true end
						return _IsPlayerCanDraw(p,ct,...)
					end
	Duel.IsPlayerCanSendtoHand=function(p,...)
						local c=table.unpack({...})
						if aux.GetValueType(c)~="Card" then return _IsPlayerCanSendtoHand(p,...) end
						local dg=Group.FromCards(c):Filter(Card.IsLocation,nil,LOCATION_DECK):Filter(Card.IsAbleToRemove,nil)
						if t==Duel.GetTurnCount() and #dg>0 and Duel.IsPlayerCanRemove(p,c) then return true end
						return _IsPlayerCanSendtoHand(p,...)
					end
	Card.IsAbleToGrave=function(c,...)
						if aux.GetValueType(c)~="Card" then return _IsAbleToGrave(c,...) end
						local dg=Group.FromCards(c):Filter(Card.IsLocation,nil,LOCATION_DECK):Filter(Card.IsAbleToRemove,nil)
						if t==Duel.GetTurnCount() and #dg>0 and c:IsAbleToRemove() then return true end
						return _IsAbleToGrave(c,...)
					end
	Duel.IsPlayerCanDiscardDeck=function(p,ct,...)
						local dg=Duel.GetDecktopGroup(p,ct):Filter(Card.IsAbleToRemove,nil)
						if t==Duel.GetTurnCount() and r&REASON_EFFECT>0 and #dg==ct then return true end
						return _IsPlayerCanDiscardDeck(p,ct,...)
					end
	Duel.IsPlayerCanSendtoGrave=function(p,...)
						local c=table.unpack({...})
						if aux.GetValueType(c)~="Card" then return _IsPlayerCanSendtoGrave(p,...) end
						local dg=Group.FromCards(c):Filter(Card.IsLocation,nil,LOCATION_DECK):Filter(Card.IsAbleToRemove,nil)
						if t==Duel.GetTurnCount() and #dg>0 and Duel.IsPlayerCanRemove(p,c) then return true end
						return _IsPlayerCanSendtoGrave(p,...)
					end
	Card.IsCanBeSpecialSummoned=function(c,e,st,sp,...)
						if aux.GetValueType(c)~="Card" then return _IsCanBeSpecialSummoned(c,e,st,sp,...) end
						local dg=Group.FromCards(c):Filter(Card.IsLocation,nil,LOCATION_DECK):Filter(Card.IsAbleToRemove,nil)
						if t==Duel.GetTurnCount() and #dg>0 then
							local nc,nl,pos,tgp=table.unpack({...})
							pos=pos or POS_FACEUP
							tgp=tgp or sp
							return Duel.IsPlayerCanSpecialSummon(sp,st,pos,tgp,c)
						end
						return _IsCanBeSpecialSummoned(c,e,st,sp,...)
					end
	--[[Duel.IsPlayerCanSpecialSummon=function(sp,...)
						local st,pos,top,c=table.unpack({...})
						if aux.GetValueType(c)~="Card" then return _IsPlayerCanSpecialSummon(sp,...) end
						local dg=Group.FromCards(c):Filter(Card.IsLocation,nil,LOCATION_DECK):Filter(Card.IsAbleToRemove,nil)
						if t==Duel.GetTurnCount() and #dg>0 then return true end
						return _IsPlayerCanSpecialSummon(sp,...)
					end--]]
	local _SetOperationInfo=Duel.SetOperationInfo
	Duel.SetOperationInfo=function(ev,cat,g,ct,tgp,param)
						if t==Duel.GetTurnCount() and (cat==CATEGORY_SPECIAL_SUMMON or cat==CATEGORY_TOHAND or cat==CATEGORY_TOGRAVE) and param&LOCATION_DECK>0 and Duel.IsPlayerCanRemove(Duel.GetChainInfo(0,CHAININFO_TRIGGERING_PLAYER)) then
							_SetOperationInfo(ev,cat,nil,ct,tgp,LOCATION_REMOVED)
							cat=CATEGORY_REMOVE
						end
						return _SetOperationInfo(ev,cat,g,ct,tgp,param)
					end
	if not cm[t] then
		cm[t]=true
		local e5=Effect.CreateEffect(c)
		e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e5:SetCode(EVENT_CHAINING)
		e5:SetLabel(t)
		e5:SetOperation(cm.costop2)
		e5:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e5,0)
	end
end
function cm.costop2(e,tp,eg,ep,ev,re,r,rp)
	cm[re]=cm[re] or re:GetCategory()
	cm.t=cm.t or {}
	if e:GetLabel()==Duel.GetTurnCount() and Duel.IsPlayerCanRemove(ep) and re:GetCategory()&(CATEGORY_DRAW|CATEGORY_SEARCH|CATEGORY_DECKDES)>0 then
		re:SetCategory((cm[re]|CATEGORY_REMOVE)&~(CATEGORY_DRAW|CATEGORY_SEARCH|CATEGORY_DECKDES))
		cm.t[re]=re:GetCategory()
	elseif cm.t[re] and (cm.t[re]==re:GetCategory()) then
		re:SetCategory(cm[re])
	end
end