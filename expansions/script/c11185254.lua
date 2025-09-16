--婕拉镭
local cm,m=GetID()
function cm.initial_effect(c)
	--remove and search
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_REMOVE+CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,m)
	e1:SetCost(cm.rmcost)
	e1:SetTarget(cm.rmtg)
	e1:SetOperation(cm.rmop)
	c:RegisterEffect(e1)
	cm.discard_effect=e1
	--synchro summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_REMOVE)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,m+1)
	e2:SetTarget(cm.sctg)
	e2:SetOperation(cm.scop)
	c:RegisterEffect(e2)

end
function cm.rmcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsDiscardable() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST+REASON_DISCARD)
end
function cm.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,LOCATION_HAND+LOCATION_ONFIELD+LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_HAND+LOCATION_ONFIELD+LOCATION_GRAVE)
end
function cm.thfilter(c)
	return c:IsSetCard(0xa450) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function cm.rmop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,Card.IsAbleToRemove,tp,LOCATION_HAND+LOCATION_ONFIELD+LOCATION_GRAVE,0,1,1,nil)
	if #g>0 and Duel.Remove(g,POS_FACEUP,REASON_EFFECT)~=0 then
		local tc=g:GetFirst()
		if tc:IsSetCard(0xa450) and Duel.IsExistingMatchingCard(cm.thfilter,tp,LOCATION_DECK,0,1,nil)
			and Duel.SelectYesNo(tp,aux.Stringid(m,0)) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			local sg=Duel.SelectMatchingCard(tp,cm.thfilter,tp,LOCATION_DECK,0,1,1,nil)
			Duel.SendtoHand(sg,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,sg)
		end
	end
end

function cm.symfil(c,e) 
  return c:IsType(TYPE_MONSTER) and c:IsCanBeSynchroMaterial()  and c:IsAbleToDeck() and not c:IsImmuneToEffect(e)  
end 
function cm.espfil(c,e,tp,mg) 
	return mg:CheckWithSumEqual(Card.GetSynchroLevel,c:GetLevel(),#mg,#mg,c) and c:IsSynchroSummonable(nil,mg) --and mg:GetSum(Card.GetSynchroLevel,c)==c:GetLevel()  
	--false. GetSum(Card.GetSynchroLevel)~=c:GetLevel(). CheckWithSumEqual~=GetSum.
end   
function cm.espfil2(g,c) 
	return g:CheckWithSumEqual(Card.GetSynchroLevel,c:GetLevel(),#g,#g,c) and c:IsSynchroSummonable(nil,g) and c:IsAttribute(ATTRIBUTE_WIND)
end  
function cm.symgck(g,e,tp)
	return Duel.IsExistingMatchingCard(cm.espfil,tp,LOCATION_EXTRA,0,1,nil,e,tp,g) 
end 
function cm.slfilter(c,sc,lv)
	return c:GetSynchroLevel(sc)==lv
end
function Auxiliary.SynMixFilter4(c,f4,minc,maxc,syncard,mg1,smat,c1,c2,c3,gc,mgchk)
	cm.fparams={f4,c1,c2,c3}
	if f4 and not f4(c,syncard,c1,c2,c3) then return false end
	local sg=Group.FromCards(c1,c)
	sg:AddCard(c1)
	if c2 then sg:AddCard(c2) end
	if c3 then sg:AddCard(c3) end
	local mg=mg1:Clone()
	if f4 then
		mg=mg:Filter(f4,sg,syncard,c1,c2,c3)
	else
		mg:Sub(sg)
	end
	return Auxiliary.SynMixCheck(mg,sg,minc-1,maxc-1,syncard,smat,gc,mgchk)
end
function cm.sctg(e,tp,eg,ep,ev,re,r,rp,chk) 
	local g=Duel.GetMatchingGroup(cm.symfil,tp,LOCATION_MZONE+LOCATION_GRAVE+LOCATION_REMOVED,0,nil,e)
	if chk==0 then
		cm.SubGroupParams={nil,Card.GetLevel,nil,false,true}
		--local res=Group.CheckSubGroup(g,cm.symgck,1,3,e,tp)
		local res=Group.CheckSubGroup(g,cm.symgck,1,3,e,tp)
		cm.SubGroupParams={}
		return res
	end 
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA) 
end 
function cm.espfil3(c,g,e,tp) 
	cm.SubGroupParams={nil,Card.GetLevel,nil,false,true}
	local res=Group.CheckSubGroup(g,cm.symgck,1,3,e,tp)
	--local res=Group.SelectSubGroup(g,tp,cm.espfilr,false,1,3,e,tp,c)
	cm.SubGroupParams={}
	return res and c:IsType(TYPE_SYNCHRO)
	--return c:IsSynchroSummonable(nil,g)  
end 
function cm.espfilr(mg,e,tp,c) 
	return mg:CheckWithSumEqual(Card.GetSynchroLevel,c:GetLevel(),#mg,#mg,c) and c:IsSynchroSummonable(nil,mg) --and mg:GetSum(Card.GetSynchroLevel,c)==c:GetLevel()  
	--false. GetSum(Card.GetSynchroLevel)~=c:GetLevel(). CheckWithSumEqual~=GetSum.
end   
function cm.scop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler() 
	cm.fparams=nil
	local g=Duel.GetMatchingGroup(cm.symfil,tp,LOCATION_MZONE+LOCATION_GRAVE+LOCATION_REMOVED,0,nil,e) 
	local tc=Duel.SelectMatchingCard(tp,cm.espfil3,tp,LOCATION_EXTRA,0,1,1,nil,g,e,tp):GetFirst()
	cm.SubGroupParams={function(c,sc) return c:GetSynchroLevel(tc)==sc:GetSynchroLevel(tc) and (not cm.fparams or (cm.fparams[1](c,tc,table.unpack(cm.fparams,2))==cm.fparams[1](sc,tc,table.unpack(cm.fparams,2)))) end,Card.GetLevel,nil,false}
	local mat1=g:SelectSubGroup(tp,cm.espfil2,false,1,3,tc)  
	cm.SubGroupParams={}
	cm.fparams=nil
	if mat1:IsExists(function(c) return c:IsLocation(LOCATION_MZONE) and c:IsFacedown() or c:IsLocation(LOCATION_HAND) end,1,nil) then 
			local cg=mat1:Filter(function(c) return c:IsLocation(LOCATION_MZONE) and c:IsFacedown() or c:IsLocation(LOCATION_HAND) or c:IsLocation(LOCATION_DECK) end,nil) 
			Duel.ConfirmCards(1-tp,cg)
	end 
	tc:SetMaterial(mat1)		 
	Duel.SendtoDeck(mat1,nil,SEQ_DECKTOP,REASON_EFFECT+REASON_MATERIAL+REASON_SYNCHRO) 
	local p=tp
		for i=1,2 do
		local dg=mat1:Filter(function(c,tp) return c:IsLocation(LOCATION_DECK) and c:IsControler(tp) end,nil,p)
			if #dg>1 then
			Duel.SortDecktop(tp,p,#dg)
			end
				for i=1,#dg do
				local mg=Duel.GetDecktopGroup(p,1)
				Duel.MoveSequence(mg:GetFirst(),SEQ_DECKBOTTOM)
				end
			p=1-tp
		end
	Duel.BreakEffect()
	Duel.SpecialSummon(tc,SUMMON_TYPE_SYNCHRO,tp,tp,false,false,POS_FACEUP) 
	tc:CompleteProcedure()  
end 


