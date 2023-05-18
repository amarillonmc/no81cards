--真现世与冥界的逆转
local m=82209077
local cm=_G["c"..m]
function cm.initial_effect(c)
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e0:SetCode(EVENT_ADJUST)
	e0:SetOperation(cm.op)
	Duel.RegisterEffect(e0,tp)
end

cm.is_01_tougou=true

function cm.op(e,tp,eg,ep,ev,re,r,rp)
	if not cm.oped then
		cm.oped=true
		local g=cm.fun3(cm.opfilter,tp,0xff,0xff,nil)
		Duel.Hint(HINT_CARD,0,m)
		Duel.SendtoGrave(g,REASON_RULE)
		Duel.DiscardDeck(tp,24,REASON_RULE)
		Duel.DiscardDeck(1-tp,24,REASON_RULE)
	end
end

function cm.opfilter(c)
	return c.is_01_tougou
end

if not cm.flip then

	cm.flip=true

	function cm.verify(s,o)
		local sf=0x10
		local of=0x10
		if s==0 then sf=0 end
		if o==0 then of=0 end
		return sf,of
	end

	cm.is_real_location=Card.IsLocation

	Card.IsLocation=function (c,location,...)
		return location==0x10  
	end

	Card.GetLocation=function (c,...)
		return 0x10
	end

	Card.GetPreviousLocation=function (c,...)
		return 0x10
	end
	
	cm.fun1=Duel.GetFieldGroup
	Duel.GetFieldGroup=function (c,s,o,...)
		local sf,of=cm.verify(s,o)
		return cm.fun1(c,sf,of,...)
	end

	cm.fun2=Duel.GetFieldGroupCount
	Duel.GetFieldGroupCount=function (c,s,o,...)
		local sf,of=cm.verify(s,o)
		return cm.fun2(c,sf,of,...)
	end

	cm.fun3=Duel.GetMatchingGroup
	Duel.GetMatchingGroup=function (f,player,s,o,ex,...)
		local sf,of=cm.verify(s,o)
		return cm.fun3(f,player,sf,of,ex,...)
	end

	cm.fun4=Duel.GetMatchingGroupCount
	Duel.GetMatchingGroupCount=function (f,player,s,o,ex,...)
		local sf,of=cm.verify(s,o)
		return cm.fun4(f,player,sf,of,ex,...)
	end

	cm.fun5=Duel.IsExistingMatchingCard
	Duel.IsExistingMatchingCard=function (f,player,s,o,count,ex,...)
		local sf,of=cm.verify(s,o)
		return cm.fun5(f,player,sf,of,count,ex,...)
	end

	cm.fun6=Duel.IsExistingTarget
	Duel.IsExistingTarget=function (f,player,s,o,count,ex,...)
		local sf,of=cm.verify(s,o)
		return cm.fun6(f,player,sf,of,count,ex,...)
	end

	cm.fun7=Duel.SelectMatchingCard
	Duel.SelectMatchingCard=function (sel_player,f,player,s,o,min,max,ex,...)
		local sf,of=cm.verify(s,o)
		return cm.fun7(sel_player,f,player,sf,of,min,max,ex,...)
	end

	cm.fun8=Duel.SelectTarget
	Duel.SelectTarget=function (sel_player,f,player,s,o,min,max,ex,...)
		local sf,of=cm.verify(s,o)
		return cm.fun8(sel_player,f,player,sf,of,min,max,ex,...)
	end

	cm.fun9=Duel.GetFirstMatchingCard
	Duel.GetFirstMatchingCard=function (f,player,s,o,ex,...)
		local sf,of=cm.verify(s,o)
		return cm.fun9(f,player,s,o,ex,...)
	end

	cm.fun10=Duel.DiscardHand
	Duel.DiscardHand=function (player,f,min,max,reason,ex,...)
		local g=cm.fun3(f,player,0x10,0,ex,...):FilterSelect(player,Card.IsAbleToRemove,min,max,ex,...)
		Duel.Remove(g,POS_FACEUP,reason)
	end
	
	cm.fun11=Duel.CheckReleaseGroup
	Duel.CheckReleaseGroup=function (player,f,count,ex,...)
		return cm.fun3(f,player,0x10,0,ex,...):IsExists(Card.IsAbleToRemove,f,count,ex,...)
	end

	cm.is_able_to_grave=Card.IsAbleToGrave
	Card.IsAbleToGrave=function (c,...)
		if cm.is_real_location(c,0x10) then
			return c:IsAbleToRemove()
		else
			return cm.is_able_to_grave(c)
		end
	end

	cm.is_able_to_grave_as_cost=Card.IsAbleToGraveAsCost
	Card.IsAbleToGraveAsCost=function (c,...)
		if cm.is_real_location(c,0x10) then
			return c:IsAbleToRemoveAsCost()
		else
			return cm.is_able_to_grave_as_cost(c)
		end
	end

	cm.is_discardable=Card.IsDiscardable
	Card.IsDiscardable=function (c,reason)
		if not reason then reason=REASON_COST end
		if cm.is_real_location(c,0x10) then
			if reason==REASON_COST then
				return c:IsAbleToRemoveAsCost()
			else
				return c:IsAbleToRemove()
			end
		else
			return cm.is_discardable(c,reason)
		end
	end

	cm.send_to_grave=Duel.SendtoGrave
	Duel.SendtoGrave=function (targets,reason,...)
		if targets==nil then return 0 end
		if aux.GetValueType(targets)=="Card" then
			local g=Group.FromCards(targets)
			targets=g
		end
		local sg=Group.CreateGroup()
		local tc=targets:GetFirst()
		while tc do
			if cm.is_real_location(tc,0x10) then
				sg:AddCard(tc)
				targets:RemoveCard(tc)
			end
			tc=targets:GetNext()
		end
		Duel.Remove(sg,POS_FACEUP,reason)
		return cm.send_to_grave(targets,reason)
	end

	cm.destroy=Duel.Destroy
	Duel.Destroy=function (targets,reason,dest)
		if not dest then dest=0x10 end
		if targets==nil then return 0 end
		if aux.GetValueType(targets)=="Card" then
			local g=Group.FromCards(targets)
			targets=g
		end
		local sg=Group.CreateGroup()
		local tc=targets:GetFirst()
		while tc do
			if cm.is_real_location(tc,0x10) then
				sg:AddCard(tc)
				targets:RemoveCard(tc)
			end
			tc=targets:GetNext()
		end
		Duel.Remove(sg,POS_FACEUP,reason)
		return cm.destroy(targets,reason,dest)
	end

	cm.release=Duel.Release
	Duel.Release=function (targets,reason)
		if targets==nil then return 0 end
		if aux.GetValueType(targets)=="Card" then
			local g=Group.FromCards(targets)
			targets=g
		end
		local sg=Group.CreateGroup()
		local tc=targets:GetFirst()
		while tc do
			if cm.is_real_location(tc,0x10) then
				sg:AddCard(tc)
				targets:RemoveCard(tc)
			end
			tc=targets:GetNext()
		end
		Duel.Remove(sg,POS_FACEUP,reason)
		return cm.release(targets,reason)
	end
end
