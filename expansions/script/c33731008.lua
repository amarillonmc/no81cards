--[[
GO！GO！薮猫！
GO! GO! Serval!
VAI! VAI! Servàlo!
Card Author: nemoma
Scripted by: XGlitchy30
]]

local s,id=GetID()
Duel.LoadScript("glitchylib_vsnemo.lua")
function s.initial_effect(c)
	c:EnableReviveLimit()
	aux.EnablePendulumAttribute(c,false)
	aux.AddFusionProcFunRep(c,s.ffilter,5,true)
	local CF=Effect.CreateEffect(c)
	CF:Desc(0)
	CF:SetType(EFFECT_TYPE_FIELD)
	CF:SetCode(EFFECT_SPSUMMON_PROC)
	CF:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	CF:SetRange(LOCATION_EXTRA)
	CF:SetCondition(s.ContactFusionConditionGlitchy(s.cffilter,LOCATION_MZONE|LOCATION_HAND|LOCATION_GRAVE,0,SUMMON_TYPE_SPECIAL,nil))
	CF:SetOperation(s.ContactFusionOperationGlitchy(s.cffilter,LOCATION_MZONE|LOCATION_HAND|LOCATION_GRAVE,0,SUMMON_TYPE_SPECIAL,aux.tdcfop(c)))
	CF:SetValue(0)
	c:RegisterEffect(CF)
	--[[Each time you would add a card from your Deck or GY to your hand (except by drawing), you also add 2 other cards with the same name as that card from your Deck or GY to your hand.
	If you cannot, send that card to the GY (or leave it in the GY, if it is already there) instead of adding it to your hand.]]
	local p1=Effect.CreateEffect(c)
	p1:SetType(EFFECT_TYPE_FIELD)
	p1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	p1:SetCode(id)
	p1:SetRange(LOCATION_PZONE)
	p1:SetTargetRange(1,0)
	c:RegisterEffect(p1)
	--Cannot be destroyed by battle while you have 3 or more cards with the same name in your GY
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e1:SetCondition(s.indcon)
	e1:SetValue(1)
	c:RegisterEffect(e1)
	--Cannot be destroyed by card effects while you control 3 or more cards with the same name
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e2:SetCondition(s.indcon2)
	e2:SetValue(1)
	c:RegisterEffect(e2)
	--If this card is in your GY: You can banish 5 other cards with the same name from your GY; place this card in your Pendulum Zone.
	local e3=Effect.CreateEffect(c)
	e3:Desc(1)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCost(s.pencost)
	e3:SetTarget(s.pentg)
	e3:SetOperation(s.penop)
	c:RegisterEffect(e3)
	if not s.global_check then
		s.global_check=true
		
		local _SendtoHand = Duel.SendtoHand
		
		Duel.SendtoHand = function(g,p,r,...)
			local x={...}
			local rp=#x>0 and x[1] or nil
			local tp = rp~=nil and rp or self_reference_tp
			if r&REASON_DRAW==0 and Duel.IsPlayerAffectedByEffect(tp,id) and (not p or p==tp) then
				if aux.GetValueType(g)=="Card" then
					g=Group.FromCards(g)
				end
				local sg=g:Filter(s.filter,nil,tp)
				if #sg>0 then
					local sg2=sg:Clone()
					local tg=Group.CreateGroup()
					for tc in aux.Next(sg) do
						local cg=Duel.GetMatchingGroup(aux.NecroValleyFilter(s.thfilter),tp,LOCATION_DECK|LOCATION_GRAVE,0,sg,{tc:GetCode()})
						if #cg<2 then
							tg:AddCard(tc)
						else
							Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
							local hg=cg:Select(tp,2,2,sg)
							if #hg>0 then
								sg2:Merge(hg)
							end
						end
					end
					sg2:Sub(tg)
					tg=tg:Filter(aux.NOT(Card.IsLocation),nil,LOCATION_GRAVE)
					Duel.Hint(HINT_CARD,tp,id)
					local ct=0
					if #sg2>0 then
						ct=_SendtoHand(sg2,p,r,...)
					end
					if #tg>0 then
						Duel.SendtoGrave(tg,REASON_EFFECT)
					end
					return ct
				end
			end
			return _SendtoHand(g,p,r,...)
		end
		
	end
end
function s.filter(c,p)
	return c:IsLocation(LOCATION_DECK|LOCATION_GRAVE) and c:IsControler(p)
end
function s.thfilter(c,codes)
	return c:IsCode(table.unpack(codes)) and c:IsAbleToHand()
end

--CONTACT FUSION OPTIMIZATION
function s.ffilter(c,fc,sub,mg,sg)
	if not c:IsFusionType(TYPE_MONSTER)
		or (sg and not c:IsFusionCode(sg:GetFirst():GetFusionCode()))
		or Duel.GetMatchingGroupCount(Card.IsFusionCode,self_reference_tp,LOCATION_MZONE|LOCATION_HAND|LOCATION_GRAVE,0,c,c:GetFusionCode())<4 then
		return false
	end
	return not sg or sg:FilterCount(aux.TRUE,c)==0 or not sg:IsExists(aux.NOT(Card.IsFusionCode),1,c,c:GetFusionCode())
end
function s.cffilter(c,fc)
	return c:IsFusionType(TYPE_MONSTER) and c:IsAbleToDeckOrExtraAsCost()
end
function s.ContactFusionConditionGlitchy(filter,self_location,opponent_location,sumtype,condition)
	local chkfnf = sumtype==SUMMON_TYPE_FUSION and 0 or 0x200
	return	function(e,c)
				if c==nil then return true end
				if c:IsType(TYPE_PENDULUM) and c:IsFaceup() then return false end
				local tp=c:GetControler()
				local mg=Duel.GetMatchingGroup(Auxiliary.ContactFusionMaterialFilterGlitchy,tp,self_location,opponent_location,c,c,filter,sumtype)
				local fuschk=false
				
				local exg=Group.CreateGroup()
				for tc in aux.Next(mg) do
					if not exg:IsContains(tc) then
						local g=mg:Filter(Card.IsFusionCode,nil,tc:GetFusionCode())
						if #g>=5 then
							fuschk=c:CheckFusionMaterial(g,nil,tp|chkfnf)
							if fuschk then
								break
							end
						else
							exg:Merge(g)
						end
					end
				end
				return (sumtype==0 or c:IsCanBeSpecialSummoned(e,sumtype,tp,false,false)) and fuschk
					and (not condition or condition(e,c,tp,mg))
			end
end
function s.ContactFusionOperationGlitchy(filter,self_location,opponent_location,sumtype,mat_operation,operation_params)
	local chkfnf = sumtype==SUMMON_TYPE_FUSION and 0 or 0x200
	return	function(e,tp,eg,ep,ev,re,r,rp,c)
				local mg=Duel.GetMatchingGroup(Auxiliary.ContactFusionMaterialFilterGlitchy,tp,self_location,opponent_location,c,c,filter,sumtype)
				local g=Duel.SelectFusionMaterial(tp,c,mg,nil,tp|chkfnf)
				c:SetMaterial(g)
				local gg=g:Filter(Card.IsLocation,nil,LOCATION_GRAVE)
				if #gg>0 then
					Duel.HintSelection(gg)
				end
				mat_operation(g)
			end
end

--E1
function s.gcheck(g)
	return g:GetClassCount(Card.GetCode)==1
end
function s.indcon(e)
	local g=Duel.GetFieldGroup(e:GetHandlerPlayer(),LOCATION_GRAVE,0)
	return #g>=3 and g:CheckSubGroup(s.gcheck,3,3)
end

--E2
function s.indcon2(e)
	local g=Duel.GetFieldGroup(e:GetHandlerPlayer(),LOCATION_ONFIELD,0):Filter(Card.IsFaceup,nil)
	return #g>=5 and g:CheckSubGroup(s.gcheck,5,5)
end

--E3
function s.pencost(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(Card.IsAbleToRemoveAsCost,tp,LOCATION_GRAVE,0,e:GetHandler())
	if chk==0 then
		return g:CheckSubGroup(s.gcheck,5,5)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local sg=g:SelectSubGroup(tp,s.gcheck,false,5,5)
	if #sg>0 then
		Duel.Remove(sg,POS_FACEUP,REASON_COST)
	end
end
function s.pentg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckPendulumZones(tp) end
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,e:GetHandler(),1,tp,0)
end
function s.penop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToChain() then return end
	Duel.MoveToField(c,tp,tp,LOCATION_PZONE,POS_FACEUP,true)
end