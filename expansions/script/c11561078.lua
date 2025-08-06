--银河眼滅光波龙
local m=11561078
local cm=_G["c"..m]
function cm.initial_effect(c)
	--splimit
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(c11561078.splimit)
	c:RegisterEffect(e1)
	--flag
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetCode(11561078)
	e2:SetRange(LOCATION_MZONE)
	c:RegisterEffect(e2)
	--special summon
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOHAND+CATEGORY_SEARCH)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_HAND)
	e3:SetCountLimit(1,11561078)
	e3:SetCost(c11561078.spcost)
	e3:SetTarget(c11561078.sptg)
	e3:SetOperation(c11561078.spop)
	c:RegisterEffect(e3)
	if not c11561078.global_check then
		c11561078.global_check=true
		Drake_shark_AddXyzProcedure=aux.AddXyzProcedure
		function aux.AddXyzProcedure(card_c,function_f,int_lv,int_ct,function_alterf,int_dese,int_maxc,function_op)
			if card_c:IsAttribute(ATTRIBUTE_LIGHT) and int_ct>=2 then
				if function_alterf then
					Drake_shark_XyzLevelFreeOperationAlter=Auxiliary.XyzLevelFreeOperationAlter
					function Auxiliary.XyzLevelFreeOperationAlter(f,gf,minc,maxc,alterf,alterdesc,alterop)
						return  function(e,tp,eg,ep,ev,re,r,rp,c,og,min,max)
									if og and not min then
										if og:GetCount()==minc and og:IsExists(c11561078.xfilter,1,nil) then
											local ttc=og:Filter(c11561078.xfilter,nil):GetFirst()
											local tte=ttc:IsHasEffect(11561078,tp)
											tte:UseCountLimit(tp)
										end
										local sg=Group.CreateGroup()
										local tc=og:GetFirst()
										while tc do
											local sg1=tc:GetOverlayGroup()
											sg:Merge(sg1)
											tc=og:GetNext()
										end
										Duel.SendtoGrave(sg,REASON_RULE)
										c:SetMaterial(og)
										Duel.Overlay(c,og)
									else
										local mg=e:GetLabelObject()
										if mg:GetCount()==minc and mg:IsExists(c11561078.xfilter,1,nil) then
											local ttc=mg:Filter(c11561078.xfilter,nil):GetFirst()
											local tte=ttc:IsHasEffect(11561078,tp)
											tte:UseCountLimit(tp)
										end
										if e:GetLabel()==1 then
											local mg2=mg:GetFirst():GetOverlayGroup()
											if mg2:GetCount()~=0 then
												Duel.Overlay(c,mg2)
											end
										else
											local sg=Group.CreateGroup()
											local tc=mg:GetFirst()
											while tc do
												local sg1=tc:GetOverlayGroup()
												sg:Merge(sg1)
												tc=mg:GetNext()
											end
											Duel.SendtoGrave(sg,REASON_RULE)
										end
										c:SetMaterial(mg)
										Duel.Overlay(c,mg)
										mg:DeleteGroup()
									end
								end
					end
					aux.AddXyzProcedureLevelFree(card_c,c11561078.f(function_f,int_lv,card_c),c11561078.gf(int_ct,card_c:GetOwner()),int_ct-1,int_ct,function_alterf,int_dese,function_op)
					Auxiliary.XyzLevelFreeOperationAlter=Drake_shark_XyzLevelFreeOperationAlter
				else
					Drake_shark_XyzLevelFreeOperation=Auxiliary.XyzLevelFreeOperation
					function Auxiliary.XyzLevelFreeOperation(f,gf,minct,maxct)
						return  function(e,tp,eg,ep,ev,re,r,rp,c,og,min,max)
									if og and not min then
										if og:GetCount()==minct and og:IsExists(c11561078.xfilter,1,nil) then
											local ttc=og:Filter(c11561078.xfilter,nil):GetFirst()
											local tte=ttc:IsHasEffect(11561078,tp)
											tte:UseCountLimit(tp)
										end
										local sg=Group.CreateGroup()
										local tc=og:GetFirst()
										while tc do
											local sg1=tc:GetOverlayGroup()
											sg:Merge(sg1)
											tc=og:GetNext()
										end
										Duel.SendtoGrave(sg,REASON_RULE)
										c:SetMaterial(og)
										Duel.Overlay(c,og)
									else
										local mg=e:GetLabelObject()
										if mg:GetCount()==minct and mg:IsExists(c11561078.xfilter,1,nil) then
											local ttc=mg:Filter(c11561078.xfilter,nil):GetFirst()
											local tte=ttc:IsHasEffect(11561078,tp)
											tte:UseCountLimit(tp)
										end
										if e:GetLabel()==1 then
											local mg2=mg:GetFirst():GetOverlayGroup()
											if mg2:GetCount()~=0 then
												Duel.Overlay(c,mg2)
											end
										else
											local sg=Group.CreateGroup()
											local tc=mg:GetFirst()
											while tc do
												local sg1=tc:GetOverlayGroup()
												sg:Merge(sg1)
												tc=mg:GetNext()
											end
											Duel.SendtoGrave(sg,REASON_RULE)
										end
										c:SetMaterial(mg)
										Duel.Overlay(c,mg)
										mg:DeleteGroup()
									end
								end
					end
					aux.AddXyzProcedureLevelFree(card_c,c11561078.f(function_f,int_lv,card_c),c11561078.gf(int_ct,card_c:GetOwner()),int_ct-1,int_ct)
					Auxiliary.XyzLevelFreeOperation=Drake_shark_XyzLevelFreeOperation
				end
			else
				if function_alterf then
					Drake_shark_AddXyzProcedure(card_c,function_f,int_lv,int_ct,function_alterf,int_dese,int_maxc,function_op)
				else
					Drake_shark_AddXyzProcedure(card_c,function_f,int_lv,int_ct,nil,nil,int_maxc,nil)
				end
			end
		end
	end
	
end
function c11561078.splimit(e,se,sp,st)
	return se:IsHasType(EFFECT_TYPE_ACTIONS)
end
function c11561078.f(function_f,int_lv,card_c)
	return function (c)
			   return c:IsXyzLevel(card_c,int_lv) and (not function_f or function_f(c))
	end
end
function c11561078.gf(int_ct,int_tp)
	return function (g)
			   return g:GetCount()==int_ct or g:GetCount()==int_ct-1 and g:IsExists(c11561078.xfilter,1,nil,int_tp)
	end
end
function c11561078.xfilter(c,tp)
	return c:IsHasEffect(11561078,tp)
end
function c11561078.cfilter(c)
	local tp=c:GetControler()
	return c:IsCode(93717133,18963306,88177324) and Duel.IsExistingMatchingCard(c11561078.thfilter,tp,LOCATION_DECK,0,3,nil,c:GetCode()) and Duel.GetMatchingGroup(c11561078.thfilter,tp,LOCATION_DECK,0,nil,c:GetCode()):GetClassCount(Card.GetCode)>2
end
function c11561078.thfilter(c,code)
	return (code==93717133 and c:IsSetCard(0x55,0x7b)) or (code==18963306 and c:IsSetCard(0x95,0xe5)) or (code==88177324 and c:IsSetCard(0x1b4,0x175))
end
function c11561078.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c11561078.cfilter,tp,LOCATION_DECK+LOCATION_EXTRA,0,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local g=Duel.SelectMatchingCard(tp,c11561078.cfilter,tp,LOCATION_DECK+LOCATION_EXTRA,0,1,1,e:GetHandler())
	Duel.ConfirmCards(1-tp,g)
	Duel.ShuffleHand(tp)
	local tc=g:GetFirst()
	e:SetLabel(tc:GetCode())
end
function c11561078.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,0,LOCATION_DECK)
end
function c11561078.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)~=0 then
		local ccode=e:GetLabel()
			local g=Duel.GetMatchingGroup(c11561078.thfilter,tp,LOCATION_DECK,0,nil,ccode)
			if g:GetCount()>=3 then
				Duel.BreakEffect()
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
				local sg=g:SelectSubGroup(tp,aux.dncheck,false,3,3)
				Duel.ConfirmCards(1-tp,sg)
				Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_ATOHAND)
				local tg=sg:Select(1-tp,1,1,nil)
				tg:GetFirst():SetStatus(STATUS_TO_HAND_WITHOUT_CONFIRM,true)
				Duel.SendtoHand(tg,nil,REASON_EFFECT)
				Duel.ConfirmCards(1-tp,tg)
			end
	end
end